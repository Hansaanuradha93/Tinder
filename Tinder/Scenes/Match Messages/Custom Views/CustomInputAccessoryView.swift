import UIKit

class CustomInputAccessoryView: UIView {
    
    // MARK: Properties
    let textView = UITextView()
    let sendButton = TDButton(title: "SEND", titleColor: .black, fontSize: 14)

    
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
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        dropShadow(color: .lightGray, opacity: 0.1, offset: .init(width: 0, height: -8), radius: 8)
        
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        
        let dimensions: CGFloat = 60
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
