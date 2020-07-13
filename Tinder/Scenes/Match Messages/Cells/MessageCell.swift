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
    
    fileprivate let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
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
        addSubview(bubbleView)
        bubbleView.layer.cornerRadius = 12
        let anchoredConstraints = bubbleView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        anchoredConstraints.leading?.constant = 20
        anchoredConstraints.trailing?.constant = -20
        
        anchoredConstraints.trailing?.isActive = false
        
//        anchoredConstraints.leading?.isActive = false
//        anchoredConstraints.trailing?.isActive = true
        
        bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        
        bubbleView.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
}
