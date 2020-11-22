import UIKit

extension UICollectionViewFlowLayout {
    public static func squareLayout(spacing: CGFloat) -> Self {
        let layout = Self()
        layout.sectionInset = UIEdgeInsets(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing
        )
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(
            width: spacing * 6,
            height: spacing * 6
        )
        return layout
    }
}
