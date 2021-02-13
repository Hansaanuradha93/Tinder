import UIKit

class HomeTopButtonControlsStackView: UIStackView {
    
    // MARK: Properties
    let settingsButton = TDButton(type: .system)
    let fireButton = TDButton(type: .system)
    let messagesButton = TDButton(type: .system)
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
private extension HomeTopButtonControlsStackView {
    
    func setupUI() {
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        settingsButton.setImage(Asserts.profile.withRenderingMode(.alwaysOriginal), for: .normal)
        fireButton.setImage(Asserts.fireIcon.withRenderingMode(.alwaysOriginal), for: .normal)
        messagesButton.setImage(Asserts.topMessagesRight.withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingsButton, fireButton, messagesButton].forEach { button in
            addArrangedSubview(button)
        }
    }
}
