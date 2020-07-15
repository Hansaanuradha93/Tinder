import UIKit

class CustomInputAccessoryView: UIView {
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    // MARK: Overriden Methods
    override var intrinsicContentSize: CGSize {
        return .zero
    }
}


// MARK: - Methods
extension CustomInputAccessoryView {
    
    fileprivate func setupUI() {
        dropShadow(color: .lightGray, opacity: 0.1, offset: .init(width: 0, height: -8), radius: 8)
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        let textView = UITextView()
        textView.text = "It's working"
        textView.isScrollEnabled = false
        
        let dimensions: CGFloat = 60
        let sendButton = TDButton(title: "SEND", titleColor: .black, fontSize: 14)
        sendButton.setHeight(dimensions)
        sendButton.setWidth(dimensions)

        let stackView = UIStackView(arrangedSubviews: [textView, sendButton])
        stackView.alignment = .center
        addSubview(stackView)
        stackView.fillSuperview()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
