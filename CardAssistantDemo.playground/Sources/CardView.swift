import UIKit

open class CardView: UIStackView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 16,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        
        axis = .vertical
        spacing = 8
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 300)
        ])
        
        setup()
    }
    
    open func setup() {
        // Override
    }
    
    public func removeAllArrangedSubviews() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
            removeArrangedSubview(view)
        }
    }
    
    public required init(coder: NSCoder) {
        fatalError()
    }
}
