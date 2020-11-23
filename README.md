# UIKitCellConfigurator

Code example:

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

## Other examples

Have  a look at the following Xcode playground demos:

* SimpleColorDemo.playground
* ColorFibonacciDemo.playground
* TableDemo.playground
* CardAssistantDemo.playground
