import UIKit

class HomeBottomButtonControlsStackView: UIStackView {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let _ = [#imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal), #imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), #imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), #imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), #imageLiteral(resourceName: "boost_circle").withRenderingMode(.alwaysOriginal)].map { image -> UIView in
            let button = UIButton(type: .system)
            button.setImage(image, for: .normal)
            addArrangedSubview(button)
            return button
        }
    }
    
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
