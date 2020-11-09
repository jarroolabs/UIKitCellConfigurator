import UIKit

public struct CellType<T> {
    let reuseIdentifier: String
    let cellClass: T.Type
    let dequeue: (DequeueTarget<T>, IndexPath) -> T

    public init(reuseIdentifier: String, type: T.Type) {
        self.reuseIdentifier = reuseIdentifier
        
        cellClass = type
        dequeue = { collection, indexPath in
            collection.dequeueReusableCell(reuseIdentifier, indexPath)
        }
    }
}

/// Generalizes the `dequeueReusableCell()` signature.
struct DequeueTarget<Cell> {
    let dequeueReusableCell: (_ reuseIdentifier: String, _ indexPath: IndexPath) -> Cell
}

extension CellType {
    /// Convenience using a reuse identifier generated from the given type.
    public init(_ type: T.Type) {
        let reuseIdentifier = String(describing: type)
        self.init(reuseIdentifier: reuseIdentifier, type: type)
    }
}

// MARK: Convenient registration methods

extension UICollectionView {
    public func register<T: UICollectionViewCell>(cellType: CellType<T>) {
        register(cellType.cellClass, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
}

extension UICollectionViewController {
    public func register<T: UICollectionViewCell>(cellType: CellType<T>) {
        collectionView.register(cellType.cellClass, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
}

extension UITableView {
    public func register<T: UITableViewCell>(cellType: CellType<T>) {
        register(cellType.cellClass, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
}

extension UITableViewController {
    public func register<T: UITableViewCell>(cellType: CellType<T>) {
        tableView.register(cellType.cellClass, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
}
