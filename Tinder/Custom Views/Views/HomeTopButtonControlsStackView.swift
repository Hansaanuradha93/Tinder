import UIKit

class HomeTopButtonControlsStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let _ = [#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysOriginal), #imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal)].map { image -> UIView in
            let button = UIButton(type: .system)
            button.setImage(image, for: .normal)
            addArrangedSubview(button)
            return button
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
