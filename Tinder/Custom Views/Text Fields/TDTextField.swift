import UIKit

class TDTextField: UITextField {
    
    var padding: CGFloat = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    convenience init(padding: CGFloat, placeholderText: String = "", radius: CGFloat = 0) {
        self.init()
        self.padding = padding
        self.placeholder = placeholderText
        self.layer.cornerRadius = radius
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    
    fileprivate func configure() {
        backgroundColor = .white
    }
}
