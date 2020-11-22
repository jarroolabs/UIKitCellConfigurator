import UIKit

public class CollectionViewContainerCell<View>: UICollectionViewCell where View: UIView {
    public private(set) lazy var view = View()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    public required init?(coder: NSCoder) { fatalError() }
}
