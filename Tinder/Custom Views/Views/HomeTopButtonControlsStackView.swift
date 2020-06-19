import UIKit

class HomeTopButtonControlsStackView: UIStackView {
    
    let settingButton = UIButton(type: .system)
    let fireButton = UIButton(type: .system)
    let messagesButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        settingButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        fireButton.setImage(#imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        messagesButton.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingButton, fireButton, messagesButton].forEach { button in
            addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
