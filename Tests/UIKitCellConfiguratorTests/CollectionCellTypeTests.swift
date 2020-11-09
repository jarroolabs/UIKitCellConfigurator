import XCTest
@testable import UIKitCellConfigurator

final class CollectionCellTypeTests: XCTestCase {
    func testRegisterAndDequeue() {
        let collectionView = UICollectionView(
            frame: UIScreen.main.bounds,
            collectionViewLayout: UICollectionViewFlowLayout()
        )

        let cellConfiguratorA = CellConfigurator(
            modelClass: Int.self,
            cellClass: CustomCellA.self,
            configureCell: { model, cell in
                cell.intProperty = model
            }
        )

        let cellConfiguratorB = CellConfigurator(
            modelClass: String.self,
            cellClass: CustomCellB.self,
            configureCell: { model, cell in
                cell.stringProperty = model
            }
        )
        
        let cellConfiguratorC = CellConfigurator(
            modelClass: Bool.self,
            cellClass: CustomCellC<Bool>.self,
            configureCell: { model, cell in
                cell.value = model
            }
        )

        collectionView.register(cellType: cellConfiguratorA.cellType)
        collectionView.register(cellType: cellConfiguratorB.cellType)
        collectionView.register(cellType: cellConfiguratorC.cellType)

        let cellA = cellConfiguratorA.configure(
            withModel: 1,
            collectionView: collectionView,
            indexPath: IndexPath(row: 0, section: 0)
        )
        XCTAssertEqual(cellA.intProperty, 1)

        let cellB = cellConfiguratorB.configure(
            withModel: "String",
            collectionView: collectionView,
            indexPath: IndexPath(row: 0, section: 0)
        )
        XCTAssertEqual(cellB.stringProperty, "String")
        
        let cellC = cellConfiguratorC.configure(
            withModel: true,
            collectionView: collectionView,
            indexPath: IndexPath(row: 0, section: 0)
        )
        XCTAssertEqual(cellC.value, true)
    }

    func testGeneratedReuseIdentifier() {
        let customCellType = CellType(CustomCellA.self)
        XCTAssertEqual(customCellType.reuseIdentifier, "CustomCellA")

        let genericCellType = CellType(CustomCellC<Int>.self)
        XCTAssertEqual(genericCellType.reuseIdentifier, "CustomCellC<Int>")
    }

    static var allTests = [
        ("testRegisterAndDequeue", testRegisterAndDequeue),
        ("testGeneratedReuseIdentifier", testGeneratedReuseIdentifier)
    ]
}

private class CustomCellA: UICollectionViewCell {
    var intProperty: Int?
}

private class CustomCellB: UICollectionViewCell {
    var stringProperty: String?
}

private class CustomCellC<T>: UICollectionViewCell {
    var value: T?
}
