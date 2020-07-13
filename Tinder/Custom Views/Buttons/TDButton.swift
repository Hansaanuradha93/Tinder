import UIKit

class TDButton: UIButton {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    convenience init(backgroundColor: UIColor = .white, title: String = "", titleColor: UIColor = .black, radius: CGFloat = 0, fontSize: CGFloat = 32) {
        self.init(frame: .zero)
        self.setup(backgroundColor: backgroundColor, title: title, titleColor: titleColor, radius: radius, fontSize: fontSize)
    }
}


// MARK: - Methods
extension TDButton {
    
    func set(image: UIImage,withTint color: UIColor) {
        self.setImage(image, for: .normal)
        self.imageView?.image = self.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    
    fileprivate func setup(backgroundColor: UIColor, title: String, titleColor: UIColor, radius: CGFloat, fontSize: CGFloat) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = radius
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .heavy)
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
}
