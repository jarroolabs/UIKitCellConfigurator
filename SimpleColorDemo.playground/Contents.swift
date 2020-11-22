import UIKit
import PlaygroundSupport
import UIKitCellConfigurator

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


class RandomColorDataSource: NSObject, UICollectionViewDataSource {
    
    let cellConfigurator = CellConfigurator(
        modelClass: UIColor.self,
        cellClass: CollectionViewContainerCell<ColorView>.self,
        configureCell: { model, cell in
            cell.view.color = model
        }
    )
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cellConfigurator.configure(withModel: randomColor(), collectionView: collectionView, indexPath: indexPath)
    }

    private func randomColor() -> UIColor {
        let colors = [
            UIColor.systemRed,
            .systemGreen,
            .systemBlue
        ]
        return colors.randomElement() ?? .white
    }
}

//: ## Collection view controller

let layout = UICollectionViewFlowLayout()
let controller = UICollectionViewController(collectionViewLayout: layout)
let randomColorDataSource = RandomColorDataSource()

controller.collectionView.dataSource = randomColorDataSource
controller.collectionView.register(cellType: randomColorDataSource.cellConfigurator.cellType)

PlaygroundPage.current.liveView = controller
