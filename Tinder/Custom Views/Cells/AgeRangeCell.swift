import UIKit

class AgeRangeCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseIdentifier = "AgeRangeCell"
    
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .red
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
