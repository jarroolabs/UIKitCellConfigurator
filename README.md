# UIKit CellConfigurator

Example:

```swift
let cellConfigurator = CellConfigurator(
    modelClass: UIColor.self,
    cellClass: CollectionViewContainerCell<ColorView>.self,
    configureCell: { model, cell in
        cell.view.color = model
    }
)

let layout = UICollectionViewFlowLayout()
let collection = CollectionViewController(collectionViewLayout: layout)

collection.register(cellType: cellConfigurator.cellType)

collection.numberOfItems = { _ in 100 }

collection.cellForItemAt = { cv, ip in
    cellConfigurator.configure(
        withModel: randomColor(),
        collectionView: cv,
        indexPath: ip
    )
}
```
