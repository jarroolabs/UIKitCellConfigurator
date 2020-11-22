import UIKit
import PlaygroundSupport
import UIKitCellConfigurator

class PeriodicTableDataSource: NSObject, UITableViewDataSource {
    private let periodicTable = [
        Item(title: "H", subtitle: "Hydrogen"),
        Item(title: "Li", subtitle: "Lithium"),
        Item(title: "Na", subtitle: "Sodium"),
        Item(title: "K", subtitle: "Potassium"),
        Item(title: "Rb", subtitle: "Rubidium"),
        Item(title: "Cs", subtitle: "Caesium"),
        Item(title: "F", subtitle: "Francium")
    ]
    
    struct Item {
        let title: String
        let subtitle: String
    }

    let cellConfigurator = CellConfigurator(
        modelClass: Item.self,
        cellClass: TableViewSubtitleCell.self,
        configureCell: { model, cell in
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = model.subtitle
        }
    )
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        periodicTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellConfigurator.configure(
            withModel: periodicTable[indexPath.row],
            tableView: tableView,
            indexPath: indexPath
        )
    }
}

class Controller : UITableViewController {
    private let dataSource: PeriodicTableDataSource
    
    init(dataSource: PeriodicTableDataSource) {
        self.dataSource = dataSource
        super.init(style: .plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        tableView.register(cellType: dataSource.cellConfigurator.cellType)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

PlaygroundPage.current.liveView = Controller(
    dataSource: PeriodicTableDataSource()
)
