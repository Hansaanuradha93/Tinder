import UIKit

class RecentMessageCell: UICollectionViewCell {
    
    // MARK: Properties
    static let reuseID = "RecentMessageCell"
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension RecentMessageCell {
    
    fileprivate func setupUI() {
        backgroundColor = .red
    }
}
