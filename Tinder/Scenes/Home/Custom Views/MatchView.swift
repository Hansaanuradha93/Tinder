import UIKit

class MatchView: UIView {
    
    // MARK: Properties
    fileprivate let blurView = UIBlurEffect(style: .dark)
    fileprivate lazy var visualEffectView = UIVisualEffectView(effect: blurView)
    fileprivate let currentImageView = TDImageView(borderWidth: 2, borderColor: .white)
    fileprivate let cardUserImageView = TDImageView(borderWidth: 2, borderColor: .white)

    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurView()
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}


// MARK: - Methods
extension MatchView {
    
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
        
        currentImageView.image = #imageLiteral(resourceName: "kelly1") // TODO: remove this image. this one is temporary
        addSubview(currentImageView)
        currentImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: dimensions, height: dimensions))
        currentImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        currentImageView.layer.cornerRadius = dimensions / 2
        
        cardUserImageView.image = #imageLiteral(resourceName: "lady4c") // TODO: remove this image. this one is temporary
        addSubview(cardUserImageView)
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: dimensions, height: dimensions))
        cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardUserImageView.layer.cornerRadius = dimensions / 2
    }
}
