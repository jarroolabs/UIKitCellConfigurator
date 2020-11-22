import UIKit
import PlaygroundSupport
import UIKitCellConfigurator

//:### Color view and its view model
//: `ColorView` simply draws a color in a rounded corner frame.
struct ColorViewModel {
    let color: UIColor
}

class ColorView: UIView {
    var viewModel: ColorViewModel? {
        didSet {
            backgroundColor = viewModel?.color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

//:### Number view and its view model
//:`NumberView` draws a number on yellow rounded-rect.
struct NumberViewModel {
    let number: Int
}

class NumberView: UILabel {
    var viewModel: NumberViewModel? {
        didSet {
            text = (viewModel?.number).map { "\($0)" }
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

//:### FibonacciColor ViewModel
//:The view model handles and represents the data model for the Fibonacci color collection view controller. It knows how to fetch items, and maps them into the view models defined earlier.
class FibonacciColorViewModel {
    private var items = [Item]()

    enum Item {
        case color(ColorViewModel)
        case number(NumberViewModel)
    }
    
    func fetch(completion: @escaping () -> Void) {
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
    
    func fetchItems() -> [FibonacciColorViewModel.Item] {
        [
            .color(.init(color: .systemRed)),
            .number(.init(number: 1)),
            .color(.init(color: .systemGreen)),
            .number(.init(number: 1)),
            .color(.init(color: .systemBlue)),
            .number(.init(number: 2)),
            .color(.init(color: .systemIndigo)),
            .number(.init(number: 3)),
            .color(.init(color: .systemGreen)),
            .number(.init(number: 5)),
            .color(.init(color: .systemBlue)),
            .number(.init(number: 8)),
            .color(.init(color: .systemIndigo)),
            .number(.init(number: 13)),
            .color(.init(color: .systemRed)),
            .number(.init(number: 21)),
            .color(.init(color: .systemGreen)),
            .number(.init(number: 34)),
            .color(.init(color: .systemBlue)),
            .number(.init(number: 55)),
            .color(.init(color: .systemIndigo)),
            .number(.init(number: 89)),
            .color(.init(color: .systemGreen)),
            .number(.init(number: 144)),
            .color(.init(color: .systemBlue)),
            .number(.init(number: 233)),
            .color(.init(color: .systemIndigo)),
            .number(.init(number: 377))
        ]
    }
}

//:### FibonacciColorDataSource
//:This data source acts as an adapter for `FibonacciColorViewModel`, making it fit the `UICollectionViewDataSource` API. It defines the required cell configurators, and invokes them according to the data represented by the view model.
class FibonacciColorDataSource: NSObject, UICollectionViewDataSource {
    private let viewModel: FibonacciColorViewModel
    
    let colorCellConfigurator = CellConfigurator(
        modelClass: ColorViewModel.self,
        cellClass: CollectionViewContainerCell<ColorView>.self
    ) { viewModel, cell in
        cell.view.viewModel = viewModel
    }

    let numberCellConfigurator = CellConfigurator(
        modelClass: NumberViewModel.self,
        cellClass: CollectionViewContainerCell<NumberView>.self
    ) { viewModel, cell in
        cell.view.viewModel = viewModel
    }
    
    init(viewModel: FibonacciColorViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    func registerCellConfigurators(on collectionView: UICollectionView) {
        collectionView.register(cellType: dataSource.colorCellConfigurator.cellType)
        collectionView.register(cellType: dataSource.numberCellConfigurator.cellType)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch viewModel.item(at: indexPath) {
        
        case let .color(color):
            return colorCellConfigurator.configure(
                withModel: color,
                collectionView: collectionView,
                indexPath: indexPath
            )
            
        case let .number(number):
            return numberCellConfigurator.configure(
                withModel: number,
                collectionView: collectionView,
                indexPath: indexPath
            )
        }
    }
}

//:### Wiring everything together...
let viewModel = FibonacciColorViewModel()
let dataSource = FibonacciColorDataSource(viewModel: viewModel)
let controller = UICollectionViewController(
    collectionViewLayout: UICollectionViewFlowLayout.squareLayout(spacing: 16)
)

controller.collectionView.backgroundColor = .black
controller.collectionView.dataSource = dataSource

dataSource.registerCellConfigurators(on: controller.collectionView)

viewModel.fetch {
    controller.collectionView.reloadData()
}

PlaygroundPage.current.liveView = controller
