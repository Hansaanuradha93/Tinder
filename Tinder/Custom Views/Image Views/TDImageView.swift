import UIKit

class TDImageView: UIImageView {
    
    // MARK: Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    convenience init(image: UIImage = Asserts.placeHolder, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        self.init(frame: .zero)
        self.image = image
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}


// MARK: - Methods
extension TDImageView {
    
    fileprivate func setupUI() {
        image = Asserts.placeHolder
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
