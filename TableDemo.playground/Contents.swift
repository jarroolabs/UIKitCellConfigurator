import UIKit
import PlaygroundSupport
import UIKitCellConfigurator
import UIKitCellConfiguratorHelpers

class Controller : UITableViewController {
    
    struct Item {
        let title: String
        let subtitle: String
    }

    let periodicTable = [
        Item(title: "H", subtitle: "Hydrogen"),
        Item(title: "Li", subtitle: "Lithium"),
        Item(title: "Na", subtitle: "Sodium"),
        Item(title: "K", subtitle: "Potassium"),
        Item(title: "Rb", subtitle: "Rubidium"),
        Item(title: "Cs", subtitle: "Caesium"),
        Item(title: "F", subtitle: "Francium")
    ]
    
    let cellConfigurator = CellConfigurator(
        modelClass: Item.self,
        cellClass: TableViewSubtitleCell.self,
        configureCell: { model, cell in
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = model.subtitle
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: cellConfigurator.cellType)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        periodicTable.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellConfigurator.configure(
            withModel: periodicTable[indexPath.row],
            tableView: tableView,
            indexPath: indexPath
        )
    }
}

PlaygroundPage.current.liveView = Controller()
