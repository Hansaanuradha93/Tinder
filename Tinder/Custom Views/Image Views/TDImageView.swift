import UIKit

class TDImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    convenience init(borderWidth: CGFloat, borderColor: UIColor) {
        self.init(frame: .zero)
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    
    fileprivate func setupUI() {
        image = Asserts.placeHolder
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
