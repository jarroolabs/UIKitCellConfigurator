import UIKit

public struct CellConfigurator<Model, Cell> {
    public let cellType: CellType<Cell>
    let configureCell: (Model, Cell) -> Void
}

extension CellConfigurator {
    public init(
        modelClass: Model.Type,
        cellType: CellType<Cell>,
        configureCell: @escaping (Model, Cell) -> Void
    ) {
        self.init(cellType: cellType, configureCell: configureCell)
    }

    public init(
        modelClass: Model.Type,
        cellClass: Cell.Type,
        configureCell: @escaping (Model, Cell) -> Void
    ) {
        self.init(cellType: CellType(cellClass), configureCell: configureCell)
    }
}

extension CellConfigurator where Cell: UICollectionViewCell {
    public func configure(withModel model: Model, collectionView: UICollectionView, indexPath: IndexPath) -> Cell {
        let dequeueTarget = DequeueTarget { (reuseIdentifier, indexPath) in
            collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            ) as! Cell
        }
        let cell = cellType.dequeue(dequeueTarget, indexPath)
        configureCell(model, cell)
        return cell
    }
}

extension CellConfigurator where Cell: UITableViewCell {
    public func configure(withModel model: Model, tableView: UITableView, indexPath: IndexPath) -> Cell {
        let dequeueTarget = DequeueTarget { (reuseIdentifier, indexPath) in
            tableView.dequeueReusableCell(
                withIdentifier: reuseIdentifier,
                for: indexPath
            ) as! Cell
        }
        let cell = cellType.dequeue(dequeueTarget, indexPath)
        configureCell(model, cell)
        return cell
    }
}
