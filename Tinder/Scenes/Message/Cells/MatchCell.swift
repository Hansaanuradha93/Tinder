import UIKit

class MatchCell: UICollectionViewCell {
    
    // MARK: Properties
    static let reuseID = "MatchCell"
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
