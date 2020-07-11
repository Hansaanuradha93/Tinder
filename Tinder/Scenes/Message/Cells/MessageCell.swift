import UIKit

class MessageCell: UICollectionViewCell {
    
    // MARK: Properties
    static let reuseID = "MessageCell"
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) { fatalError() }
}