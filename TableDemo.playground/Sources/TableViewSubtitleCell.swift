import UIKit

public class TableViewSubtitleCell: UITableViewCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder: NSCoder) { fatalError() }
}
