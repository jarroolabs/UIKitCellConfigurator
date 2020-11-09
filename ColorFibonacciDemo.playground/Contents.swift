import UIKit
import PlaygroundSupport
import UIKitCellConfigurator
import UIKitCellConfiguratorHelpers
//:
//: # Collection view generics en cell type demo
//: Demonstrates how to CellConfigurator and CellType.
//:
//: ## Cell views
//: We'll give every cell its own distinct view to display.
//:
//: * `ColorView` takes a `color` and displays it as its background.
//: * `NumberView` displays an `Int` on a yellow background.
//:
class ColorView: UIView {
    var color = UIColor.clear {
        didSet {
            layer.cornerRadius = 16
            clipsToBounds = true

            backgroundColor = color
        }
    }
}

class NumberView: UILabel {
    var number: Int? {
        didSet {
            text = number.map { "\($0)" }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        clipsToBounds = true

        textAlignment = .center
        backgroundColor = .systemYellow
    }

    required init?(coder: NSCoder) { fatalError() }
}
//:
//: ## Cell configurators
//: A cell configurator pairs a cell class with its associated model type. Whenever a cell gets dequeue, the model data is passed to the cell.
//:
let colorCellConfigurator = CellConfigurator(
    modelClass: UIColor.self,
    cellClass: CollectionViewContainerCell<ColorView>.self
) { model, cell in
    cell.view.color = model
}

let numberCellConfigurator = CellConfigurator(
    modelClass: Int.self,
    cellClass: CollectionViewContainerCell<NumberView>.self
) { model, cell in
    cell.view.number = model
}

//: ## Collection view layout
//: This demo layout just sets some parameters to get something simple running.

class DemoLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        let spacing = CGFloat(16)
        sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing
        itemSize = CGSize(
            width: spacing * 6,
            height: spacing * 6
        )
    }

    required init?(coder: NSCoder) { fatalError() }
}

struct ViewModel {
    private var items = [Item]()
    private let fetchItems: () -> [Item]

    enum Item {
        case color(UIColor)
        case number(Int)
    }
    
    init(fetchItems: @escaping () -> [Item]) {
        self.fetchItems = fetchItems
    }
    
    mutating func fetch(completion: @escaping () -> Void) {
        items = fetchItems()
        completion()
    }
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfItems() -> Int {
        items.count
    }
    
    func item(at indexPath: IndexPath) -> Item {
        items[indexPath.item]
    }
}

func fibonacciItems() -> [ViewModel.Item] {
    [
        .color(.systemRed),
        .number(1),
        .color(.systemGreen),
        .number(1),
        .color(.systemBlue),
        .number(2),
        .color(.systemIndigo),
        .number(3),
        .color(.systemGreen),
        .number(5),
        .color(.systemBlue),
        .number(8),
        .color(.systemIndigo),
        .number(13),
        .color(.systemRed),
        .number(21),
        .color(.systemGreen),
        .number(34),
        .color(.systemBlue),
        .number(55),
        .color(.systemIndigo),
        .number(89),
        .color(.systemGreen),
        .number(144),
        .color(.systemBlue),
        .number(233),
        .color(.systemIndigo),
        .number(377)
    ]
}

//: Collection View

var viewModel = ViewModel(fetchItems: fibonacciItems)

let collection = CollectionViewController(collectionViewLayout: DemoLayout())

collection.collectionView.backgroundColor = .black
collection.register(cellType: colorCellConfigurator.cellType)
collection.register(cellType: numberCellConfigurator.cellType)

collection.numberOfSections = viewModel.numberOfSections
collection.numberOfItems = { _ in viewModel.numberOfItems() }

collection.cellForItemAt = { cv, ip in
    switch viewModel.item(at: ip) {
    
    case let .color(color):
        return colorCellConfigurator.configure(
            withModel: color,
            collectionView: cv,
            indexPath: ip
        )
        
    case let .number(number):
        return numberCellConfigurator.configure(
            withModel: number,
            collectionView: cv,
            indexPath: ip
        )
    }
}

viewModel.fetch(completion: collection.collectionView.reloadData)

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = collection

