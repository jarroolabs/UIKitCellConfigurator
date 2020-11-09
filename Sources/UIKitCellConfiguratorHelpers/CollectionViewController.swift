import UIKit

public class CollectionViewController: UICollectionViewController {
    public typealias SectionIndex = Int

    public var numberOfSections: () -> Int = { 1 } {
        didSet {
            collectionView.reloadData()
        }
    }

    public var numberOfItems: (SectionIndex) -> Int = { _ in 0 } {
        didSet {
            collectionView.reloadData()
        }
    }

    public var cellForItemAt: (UICollectionView, IndexPath) -> UICollectionViewCell = { _, _ in UICollectionViewCell() } {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource

    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        numberOfSections()
    }

    public override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        numberOfItems(section)
    }

    public override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        cellForItemAt(collectionView, indexPath)
    }
}
