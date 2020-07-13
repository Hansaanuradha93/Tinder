import UIKit

class MessageCell: UICollectionViewCell {
    
    // MARK: Properties
    static let reuseID = "MessageCell"
    fileprivate let textView: UITextView = {
       let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension MessageCell {
    
    func set(message: Message) {
        textView.text = message.text ?? ""
    }
    
    
    fileprivate func setupLayout() {
        addSubview(textView)
        textView.fillSuperview()
    }
}
