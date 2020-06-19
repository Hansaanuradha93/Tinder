import UIKit

class CardView: UIView {
    
    // MARK: Properties
    let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    let informationLabel = UILabel()
    
    
    // MARK: Configurations
    fileprivate let threshold: CGFloat = 100
    var user: User!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(cardViewModel: CardViewModel) {
        self.init()
        setupViews(cardViewModel)
    }
}


// MARK: - Methods
extension CardView {
    
    @objc fileprivate func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default: ()
        }
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
        imageView.image = UIImage(named: cardViewModel.imageUrl)
        informationLabel.attributedText = cardViewModel.attributedText
        informationLabel.textAlignment = cardViewModel.textAlignment
    }
    
    
    fileprivate func layoutUI() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.textColor = .white
        informationLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        informationLabel.numberOfLines = 0
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
}
