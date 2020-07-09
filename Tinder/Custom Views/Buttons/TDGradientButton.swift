import UIKit

class TDGradientButton: UIButton {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    convenience init(backgroundColor: UIColor = .white, title: String = "", titleColor: UIColor = .black, radius: CGFloat = 0, fontSize: CGFloat = 32) {
        self.init(frame: .zero)
        self.setup(backgroundColor: backgroundColor, title: title, titleColor: titleColor, radius: radius, fontSize: fontSize)
    }
    
    
    // MARK: Overriden Methods
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupGradientView(rect)
    }
}


// MARK: - Methods
extension TDGradientButton {
    
    fileprivate func setupGradientView(_ rect: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.appColor(color: .pink).cgColor, UIColor.appColor(color: .orange).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = rect
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
