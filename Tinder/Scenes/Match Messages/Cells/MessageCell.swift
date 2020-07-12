import UIKit

class MessageCell: UICollectionViewCell {
    
    // MARK: Properties
    static let reuseID = "MessageCell"
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension MessageCell {
    
    fileprivate func setupLayout() {
        
    }
}
