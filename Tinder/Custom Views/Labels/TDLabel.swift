import UIKit

class TDLabel: UILabel {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    convenience init(text: String = "", textAlignment: NSTextAlignment = .center, textColor: UIColor = .black, fontSize: CGFloat = 16, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.numberOfLines = numberOfLines
    }
}
