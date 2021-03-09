import UIKit

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didTapCardViewBotton(cardViewModel: CardViewModel)
    func didRemove(cardView: CardView, isLiked: Bool)
}


class CardView: UIView {
    
    // MARK: Properties
    private let gradientLayer = CAGradientLayer()
    private let swipingPhotoController = SwipingPhotosViewController(isCardViewMode: true)
    private lazy var swipingView = swipingPhotoController.view!
    private let informationLabel = UILabel()
    private let moreInfoButton = TDButton()
    private let likeContainerView = UIView()
    private let dislikeContainerView = UIView()
    private let likeLabel = TDLabel(text: Strings.like, textAlignment: .center, textColor: UIColor.appColor(color: .lightGreen), fontSize: 55)
    private let dislikeLabel = TDLabel(text: Strings.nope, textAlignment: .center, textColor: UIColor.appColor(color: .pink), fontSize: 55)

    
    // MARK: Configurations
    private let threshold: CGFloat = 100
    private let barDiselectedColor = UIColor.appColor(color: .darkGray)
    var cardViewModel: CardViewModel!
    var nextCardView: CardView?
    var delegate: CardViewDelegate?
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    
    convenience init(cardViewModel: CardViewModel) {
        self.init()
        self.cardViewModel = cardViewModel
        configureGradientView()
        setupViews(cardViewModel)
    }
    
    
    required init?(coder: NSCoder) { fatalError() }

    
    // MARK: Overridden Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        addCornerRadius()
        gradientLayer.frame = self.frame
    }
}


// MARK: - Objc Methods
private extension CardView {
    
    @objc func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: cardViewModel)
    }
    
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            handleBegan()
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default: ()
        }
    }
}


// MARK: - Public Methods
extension CardView {
    
    func performSwipeAnimation(isLiked: Bool) -> CardView? {
        self.handleLike(isLiked: isLiked)
        
        var translation: CGFloat = 1000
        var angle: CGFloat = 15

        if !isLiked {
            translation = -translation
            angle = -angle
        }
        
        let duration: Double = 1
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = self
        
        CATransaction.setCompletionBlock {
            cardView.removeFromSuperview()
        }
        
        cardView.layer.add(translationAnimation, forKey: "translation")
        cardView.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
        
        return cardView.nextCardView
    }
}


// MARK: - Private Methods
private extension CardView {
    
    func handleBegan() {
        superview?.subviews.forEach({ (subview) in
            subview.layer.removeAllAnimations()
        })
    }
    
    
    func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translationX = gesture.translation(in: nil).x
        let translationDirection: CGFloat = translationX > 0 ? 1 : -1
        let shoudDismissCard = abs(translationX) > threshold
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shoudDismissCard {
                let offScreenTransform = self.transform.translatedBy(x: 1000 * translationDirection, y: 0)
                self.transform = offScreenTransform
            } else {
                self.backToIdentity()
            }
        }) { (_) in
            self.transform = .identity
            if shoudDismissCard {
                self.removeFromSuperview()
                let isLiked = translationDirection == 1 ? true : false
                self.delegate?.didRemove(cardView: self, isLiked: isLiked)
            }
        }
    }
    
    
    func backToIdentity() {
        transform = .identity
        likeContainerView.alpha = 0
        dislikeContainerView.alpha = 0
    }
    
    
    func handleLike(isLiked: Bool) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.likeContainerView.alpha = isLiked ? 1 : 0
            self.dislikeContainerView.alpha = isLiked ? 0 : 1
        })
    }
    
    
    func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let likeStartAngle = 5 * CGFloat.pi / 180
        let angle = degrees * .pi / 180

        if degrees > likeStartAngle {
            handleLike(isLiked: true)
        } else if degrees < -likeStartAngle {
            handleLike(isLiked: false)
        }
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }

    
    func setupViews(_ cardViewModel: CardViewModel) {
        swipingPhotoController.swipingDelegate = self
        swipingPhotoController.imageUrls = cardViewModel.imageUrls
        informationLabel.attributedText = cardViewModel.attributedText
        informationLabel.textAlignment = cardViewModel.textAlignment
    }
    
    
    func layoutUI() {
        configureCard()
        configureSwipingView()
        configureInformationLabel()
        configureMoreInfoButton()
        configureLikeAndDislikeLabels()
    }
    
    
    func addCornerRadius() {
        moreInfoButton.layer.cornerRadius = moreInfoButton.frame.width / 2
    }
    
    
    func configureLikeAndDislikeLabels() {
        let angle = 10 * CGFloat.pi / 180
        
        addSubview(likeContainerView)
        likeContainerView.transform = CGAffineTransform(rotationAngle: -angle)
        likeContainerView.alpha = 0
        likeContainerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 40, left: 20, bottom: 0, right: 0), size: .init(width: 130, height: 65))
        likeContainerView.addBorder(borderWidth: 5, borderColor: UIColor.appColor(color: .lightGreen), corderRadius: 8)
        likeContainerView.addSubview(likeLabel)
        likeLabel.centerInSuperview()
        
        addSubview(dislikeContainerView)
        dislikeContainerView.transform = CGAffineTransform(rotationAngle: angle)
        dislikeContainerView.alpha = 0
        dislikeContainerView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 20), size: .init(width: 160, height: 65))
        dislikeContainerView.addBorder(borderWidth: 5, borderColor: UIColor.appColor(color: .pink), corderRadius: 8)
        dislikeContainerView.addSubview(dislikeLabel)
        dislikeLabel.centerInSuperview()
    }
    
    
    func configureMoreInfoButton() {
        let image = Asserts.infoCircleFill.withRenderingMode(.alwaysTemplate)
        moreInfoButton.setImage(image, for: .normal)
        moreInfoButton.tintColor = .white
        moreInfoButton.contentVerticalAlignment = .fill
        moreInfoButton.contentHorizontalAlignment = .fill
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 20, right: 16), size: .init(width: 44, height: 44))
        moreInfoButton.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
    }
    
    
    func configureGradientView() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.insertSublayer(gradientLayer, at: 1)
    }
    
    
    func configureCard() {
        layer.cornerRadius = 10
        clipsToBounds = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    
    func configureSwipingView() {
        addSubview(swipingView)
        swipingView.fillSuperview()
    }
    
    
    func configureInformationLabel() {
        informationLabel.textColor = .white
        informationLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        informationLabel.numberOfLines = 0
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
    }
}


// MARK: - SwipingPhotosViewControllerDelegate
extension CardView: SwipingPhotosViewControllerDelegate {
    
    func didTapCardViewBottom() {
        delegate?.didTapCardViewBotton(cardViewModel: cardViewModel)
    }
}
