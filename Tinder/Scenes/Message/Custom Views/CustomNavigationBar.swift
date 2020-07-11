import UIKit

class CustomNavigationBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dropShadow(color: UIColor.black, opacity: 0.05, offset: CGSize(width: 0, height: 10), radius: 8)
    }
}


// MARK: Methods
extension CustomNavigationBar {
    
    fileprivate func setupUI() {
        backgroundColor = .white
        
    }
}
