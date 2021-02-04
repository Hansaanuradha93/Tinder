import UIKit

class MessageCell: UICollectionViewCell {
    
    // MARK: Properties
    static let reuseID = "MessageCell"
    
    private var anchoredConstraints: AnchoredConstraints?
    private let textView: UITextView = {
       let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appColor(color: .regularGray)
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
        if message.isFromCurrentUser ?? false {
            anchoredConstraints?.leading?.isActive = false
            anchoredConstraints?.trailing?.isActive = true
            bubbleView.backgroundColor = UIColor.appColor(color: .tealBlue)
            textView.textColor = .white
        } else {
            anchoredConstraints?.leading?.isActive = true
            anchoredConstraints?.trailing?.isActive = false
            bubbleView.backgroundColor = UIColor.appColor(color: .regularGray)
            textView.textColor = .black
        }
    }
    
    
    private func setupLayout() {
        addSubview(bubbleView)
        bubbleView.layer.cornerRadius = 12
        anchoredConstraints = bubbleView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        anchoredConstraints?.leading?.constant = 20
        anchoredConstraints?.trailing?.constant = -20
        anchoredConstraints?.trailing?.isActive = false
        bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        
        bubbleView.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
}
