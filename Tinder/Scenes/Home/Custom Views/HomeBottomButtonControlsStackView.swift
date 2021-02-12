import UIKit

class HomeBottomButtonControlsStackView: UIStackView {

    // MARK: Properties
    lazy var refreshButton = createButton(image: Asserts.refresh.withRenderingMode(.alwaysOriginal))
    lazy var dislikeButton = createButton(image: Asserts.dismissCircle.withRenderingMode(.alwaysOriginal))
    lazy var superLikeButton = createButton(image: Asserts.superLike.withRenderingMode(.alwaysOriginal))
    lazy var likeButton = createButton(image:  Asserts.like.withRenderingMode(.alwaysOriginal))
    lazy var thunderButton = createButton(image: Asserts.boostCircle.withRenderingMode(.alwaysOriginal))

    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    
    required init(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
private extension HomeBottomButtonControlsStackView {
    
    func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    
    func setupLayout() {
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        [refreshButton, dislikeButton, superLikeButton, likeButton, thunderButton].forEach { button in
            addArrangedSubview(button)
        }
    }
}
