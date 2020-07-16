import UIKit

class CustomInputAccessoryView: UIView {
    
    // MARK: Properties
    let textView = UITextView()
    let sendButton = TDButton(backgroundColor: UIColor.appColor(color: .pink), title: "SEND", titleColor: .white, fontSize: 14)
    let placeHolderLabel = TDLabel(text: "Enter Message", textAlignment: .left, textColor: .lightGray, fontSize: 16)
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    
    // MARK: Overriden Methods
    override var intrinsicContentSize: CGSize {
        return .zero
    }
}


// MARK: - Methods
extension CustomInputAccessoryView {
    
    @objc fileprivate func handleTextChange() {
        placeHolderLabel.isHidden = textView.text.count != 0
    }
    
    
    fileprivate func setupUI() {
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        dropShadow(color: .lightGray, opacity: 0.1, offset: .init(width: 0, height: -8), radius: 8)
        
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        sendButton.setHeight(50)
        sendButton.setWidth(80)
        sendButton.layer.cornerRadius = 10

        let stackView = UIStackView(arrangedSubviews: [textView, sendButton])
        stackView.alignment = .center
        addSubview(stackView)
        stackView.fillSuperview()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor, padding: .init(top: 8, left: 20, bottom: 0, right: 16))
        placeHolderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
    }
}
