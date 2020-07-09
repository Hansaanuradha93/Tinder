import UIKit

class MatchView: UIView {
    
    // MARK: Properties
    fileprivate let blurView = UIBlurEffect(style: .dark)
    fileprivate lazy var visualEffectView = UIVisualEffectView(effect: blurView)

    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}


// MARK: - Methods
extension MatchView {
    
    
    @objc fileprivate func handleTapDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    
    fileprivate func setupBlurView() {
        visualEffectView.alpha = 0
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
        }) { (_) in
            
        }
    }
}
