import UIKit
import PlaygroundSupport
import UIKitCellConfigurator
import UIKitCellConfiguratorHelpers

//: ## Random color generator

func randomColor() -> UIColor {
    let colors = [
        UIColor.systemRed,
        .systemGreen,
        .systemBlue
    ]
    return colors.randomElement() ?? .white
}

//: ## View

class ColorView: UIView {
    var color = UIColor.clear {
        didSet {
            clipsToBounds = true
            backgroundColor = color
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

//: ## Cell configurator

let cellConfigurator = CellConfigurator(
    modelClass: UIColor.self,
    cellClass: CollectionViewContainerCell<ColorView>.self,
    configureCell: { model, cell in
        cell.view.color = model
    }
)

//: ## Collection view controller

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

PlaygroundPage.current.liveView = collection
