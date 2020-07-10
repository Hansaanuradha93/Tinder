import UIKit

class MatchView: UIView {
    
    // MARK: Properties
    fileprivate let blurView = UIBlurEffect(style: .dark)
    fileprivate lazy var visualEffectView = UIVisualEffectView(effect: blurView)
    fileprivate let itsMatchImageView = TDImageView(image: Asserts.itsMatch)
    fileprivate let descriptionLabel = UILabel()
    fileprivate let currentImageView = TDImageView(borderWidth: 2, borderColor: .white)
    fileprivate let cardUserImageView = TDImageView(borderWidth: 2, borderColor: .white)
    fileprivate let sendMessageButton = TDGradientButton( title: "SEND MESSAGE", titleColor: .white, fontSize: 16)
    fileprivate let keepSwipingButton = TDGradientBorderButton( title: "Keep Swiping", titleColor: .white, fontSize: 16)

    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurView()
        setupUI()
        setupAnimtation()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}


// MARK: - Methods
extension MatchView {
    
    fileprivate func setupAnimtation() {
        let angle = 30 * CGFloat.pi / 180
        currentImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: 190, y: 0))
        cardUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: -190, y: 0))
        
        UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: .calculationModeCubic, animations: {
            // animation 1: translation back to original position
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentImageView.transform = CGAffineTransform(rotationAngle: angle)
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            // animation 2: rotation
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.3) {
                self.currentImageView.transform = .identity
                self.cardUserImageView.transform = .identity
            }
        }) { (_) in
            
        }
    }
    
    
    @objc fileprivate func handleTapDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    
    fileprivate func setupBlurView() {
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 1
        }) { (_) in
            
        }
    }
    
    
    fileprivate func setupUI() {
        let dimensions: CGFloat = 140
        
        addSubview(itsMatchImageView)
        addSubview(descriptionLabel)
        addSubview(currentImageView)
        addSubview(cardUserImageView)
        addSubview(sendMessageButton)
        addSubview(keepSwipingButton)
        
        descriptionLabel.text = "You and I have \nLiked eachother"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
        
        itsMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
        itsMatchImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        descriptionLabel.anchor(top: nil, leading: leadingAnchor, bottom: currentImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
        
        currentImageView.image = #imageLiteral(resourceName: "kelly1") // TODO: remove this image. this one is temporary
        currentImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: dimensions, height: dimensions))
        currentImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        currentImageView.layer.cornerRadius = dimensions / 2
        
        cardUserImageView.image = #imageLiteral(resourceName: "lady4c") // TODO: remove this image. this one is temporary
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: dimensions, height: dimensions))
        cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardUserImageView.layer.cornerRadius = dimensions / 2
        
        sendMessageButton.anchor(top: currentImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
    }
}
