import UIKit

class TDGradientButton: UIButton {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) { fatalError() }

    
    convenience init(backgroundColor: UIColor = .clear, title: String = "", titleColor: UIColor = .black, fontSize: CGFloat = 32) {
        self.init(frame: .zero)
        self.setup(backgroundColor: backgroundColor, title: title, titleColor: titleColor, fontSize: fontSize)
    }
    
    
    // MARK: Overriden Methods
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupGradientView(rect)
    }
}


// MARK: - Methods
private extension TDGradientButton {
    
    func setupGradientView(_ rect: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.appColor(color: .pink).cgColor, UIColor.appColor(color: .orange).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = rect.height / 2
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = rect
    }
    
    
    func setup(backgroundColor: UIColor, title: String, titleColor: UIColor, fontSize: CGFloat) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
}
