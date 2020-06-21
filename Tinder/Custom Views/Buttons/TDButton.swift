import UIKit

class TDButton: UIButton {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    convenience init(backgroundColor: UIColor, title: String, titleColor: UIColor = .black, radius: CGFloat = 0, fontSize: CGFloat = 32) {
        self.init(frame: .zero)
        self.setup(backgroundColor: backgroundColor, title: title, titleColor: titleColor, radius: radius, fontSize: fontSize)
    }
}


// MARK: - Methods
extension TDButton {
    
    func setup(backgroundColor: UIColor, title: String, titleColor: UIColor, radius: CGFloat = 0, fontSize: CGFloat = 32) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = radius
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .heavy)
    }
}
