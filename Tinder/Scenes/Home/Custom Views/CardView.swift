import UIKit

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didTapCardViewBotton(cardViewModel: CardViewModel)
    func didRemove(cardView: CardView, isLiked: Bool)
}


class CardView: UIView {
    
    // MARK: Properties
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let swipingPhotoController = SwipingPhotosViewController(isCardViewMode: true)
    lazy var swipingView = swipingPhotoController.view!
    fileprivate let informationLabel = UILabel()
    fileprivate let moreInfoButton = TDButton()
    fileprivate let likeContainerView = UIView()
    fileprivate let dislikeContainerView = UIView()
    fileprivate let likeLabel = TDLabel(text: "LIKE", textAlignment: .center, textColor: .green, fontSize: 55)
    fileprivate let dislikeLabel = TDLabel(text: "NOPE", textAlignment: .center, textColor: UIColor.appColor(color: .pink), fontSize: 55)

    
    // MARK: Configurations
    fileprivate let threshold: CGFloat = 100
    fileprivate let barDiselectedColor = UIColor.appColor(color: .darkGray)
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


// MARK: - Methods
extension CardView {
    
    @objc fileprivate func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: cardViewModel)
    }
    
    
    @objc fileprivate func handlePan(_ gesture: UIPanGestureRecognizer) {
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
    
    
    fileprivate func handleBegan() {
        superview?.subviews.forEach({ (subview) in
            subview.layer.removeAllAnimations()
        })
    }
    
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translationX = gesture.translation(in: nil).x
        let translationDirection: CGFloat = translationX > 0 ? 1 : -1
        let shoudDismissCard = abs(translationX) > threshold
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shoudDismissCard {
                let offScreenTransform = self.transform.translatedBy(x: 1000 * translationDirection, y: 0)
                self.transform = offScreenTransform
            } else {
                self.transform = .identity
                self.likeContainerView.alpha = 0
                self.dislikeContainerView.alpha = 0
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
    
    
    fileprivate func handleLike(isLiked: Bool) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.likeContainerView.alpha = isLiked ? 1 : 0
            self.dislikeContainerView.alpha = isLiked ? 0 : 1
        })
    }
    
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
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

    
    fileprivate func setupViews(_ cardViewModel: CardViewModel) {
        swipingPhotoController.swipingDelegate = self
        swipingPhotoController.imageUrls = cardViewModel.imageUrls
        informationLabel.attributedText = cardViewModel.attributedText
        informationLabel.textAlignment = cardViewModel.textAlignment
    }
    
    
    fileprivate func layoutUI() {
        configureCard()
        configureSwipingView()
        configureInformationLabel()
        configureMoreInfoButton()
        configureLikeAndDislikeLabels()
    }
    
    
    fileprivate func addCornerRadius() {
        moreInfoButton.layer.cornerRadius = moreInfoButton.frame.width / 2
    }
    
    
    fileprivate func configureLikeAndDislikeLabels() {
        
        let angle = 10 * CGFloat.pi / 180
        
        likeContainerView.transform = CGAffineTransform(rotationAngle: -angle)
        likeContainerView.alpha = 0
        
        addSubview(likeContainerView)
        likeContainerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 40, left: 20, bottom: 0, right: 0), size: .init(width: 130, height: 65))
        likeContainerView.layer.borderWidth = 5
        likeContainerView.layer.borderColor = UIColor.green.cgColor
        likeContainerView.layer.cornerRadius = 8
        
        likeContainerView.addSubview(likeLabel)
        likeLabel.centerInSuperview()
        
        dislikeContainerView.transform = CGAffineTransform(rotationAngle: angle)
        dislikeContainerView.alpha = 0
        
        addSubview(dislikeContainerView)
        dislikeContainerView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 20), size: .init(width: 160, height: 65))
        dislikeContainerView.layer.borderWidth = 5
        dislikeContainerView.layer.borderColor = UIColor.appColor(color: .pink).cgColor
        dislikeContainerView.layer.cornerRadius = 8
        
        dislikeContainerView.addSubview(dislikeLabel)
        dislikeLabel.centerInSuperview()
    }
    
    
    fileprivate func configureMoreInfoButton() {
        let image = Asserts.infoCircleFill.withRenderingMode(.alwaysTemplate)
        moreInfoButton.setImage(image, for: .normal)
        moreInfoButton.tintColor = .white
        moreInfoButton.contentVerticalAlignment = .fill
        moreInfoButton.contentHorizontalAlignment = .fill
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 20, right: 16), size: .init(width: 44, height: 44))
        moreInfoButton.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
    }
    
    
    fileprivate func configureGradientView() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.insertSublayer(gradientLayer, at: 1)
    }
    
    
    fileprivate func configureCard() {
        layer.cornerRadius = 10
        clipsToBounds = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    
    fileprivate func configureSwipingView() {
        addSubview(swipingView)
        swipingView.fillSuperview()
    }
    
    
    fileprivate func configureInformationLabel() {
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
