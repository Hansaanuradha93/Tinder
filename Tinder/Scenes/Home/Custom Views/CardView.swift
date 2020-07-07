import UIKit

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didRemove(cardView: CardView)
}


class CardView: UIView {
    
    // MARK: Properties
    fileprivate let swipingPhotoController = SwipingPhotosViewController(isCardViewMode: true)
    lazy var swipingView = swipingPhotoController.view!
    fileprivate let informationLabel = UILabel()
    fileprivate let moreInfoButton = TDButton()

    // MARK: Configurations
    fileprivate let threshold: CGFloat = 100
    fileprivate var cardViewModel: CardViewModel!
    fileprivate let barDiselectedColor = UIColor.appColor(color: .darkGray)
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
        setupViews(cardViewModel)
    }
    
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: Overridden Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        configureGradientView()
        addCornerRadius()
    }
}


// MARK: - Methods
extension CardView {
    
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
            }
        }) { (_) in
            self.transform = .identity
            if shoudDismissCard {
                self.removeFromSuperview()
                self.delegate?.didRemove(cardView: self)
            }
        }
    }
    
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180

        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }

    
    fileprivate func setupViews(_ cardViewModel: CardViewModel) {
        swipingPhotoController.cardViewModel = cardViewModel
        informationLabel.attributedText = cardViewModel.attributedText
        informationLabel.textAlignment = cardViewModel.textAlignment
    }
    
    
    fileprivate func layoutUI() {
        configureCard()
        configureSwipingView()
        configureInformationLabel()
        configureMoreInfoButton()
    }
    
    
    fileprivate func addCornerRadius() {
        moreInfoButton.layer.cornerRadius = moreInfoButton.frame.width / 2
    }
    
    
    @objc fileprivate func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
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
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        gradientLayer.frame = self.frame
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
