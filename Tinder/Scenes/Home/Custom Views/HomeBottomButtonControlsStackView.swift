import UIKit

class HomeBottomButtonControlsStackView: UIStackView {

    // MARK: Properties
    lazy var refreshButton = createButton(image: #imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal))
    lazy var dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal))
    lazy var superLikeButton = createButton(image: #imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal))
    lazy var likeButton = createButton(image:  #imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal))
    lazy var thunderButton = createButton(image: #imageLiteral(resourceName: "boost_circle").withRenderingMode(.alwaysOriginal))

    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    
    required init(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension HomeBottomButtonControlsStackView {
    
    fileprivate func createButton(image: UIImage) -> UIButton {
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
