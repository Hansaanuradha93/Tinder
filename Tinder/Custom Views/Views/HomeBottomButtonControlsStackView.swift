import UIKit

class HomeBottomButtonControlsStackView: UIStackView {

    // MARK: Properties
    let refreshButton = createButton(image: #imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal))
    let likeButton = createButton(image:  #imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal))
    let thunderButton = createButton(image: #imageLiteral(resourceName: "boost_circle").withRenderingMode(.alwaysOriginal))

    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}


// MARK: - Methods
extension HomeBottomButtonControlsStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    
    fileprivate func setupLayout() {
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        [refreshButton, dislikeButton, superLikeButton, likeButton, thunderButton].forEach { button in
            addArrangedSubview(button)
        }
    }
}
