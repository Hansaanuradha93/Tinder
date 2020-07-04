import UIKit

class UserDetailsViewController: UIViewController {
    
    // MARK: Properties
    let scrollView = UIScrollView()
    let profileImageView = UIImageView()
    let infoLabel = UILabel()
    let dismissButton = TDButton()
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupVisualBlurEffectView()
    }
}


// MARK: - Methods
extension UserDetailsViewController {
    
    @objc fileprivate func handleTap() {
        dismiss(animated: true)
    }
    
    
    func setup(cardViewModel: CardViewModel) {
        // TODO: Use userDetailsViewModel (viewModel for UserDetailsViewController) instead of cardViewModel
        infoLabel.attributedText = cardViewModel.attributedText
        guard let firstImageUrl = cardViewModel.imageUrls.first else { return  }
        profileImageView.downloadImage(from: firstImageUrl)
    }
    
    
    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        profileImageView.image = #imageLiteral(resourceName: "kelly1").withRenderingMode(.alwaysOriginal)
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        scrollView.addSubview(profileImageView)
        profileImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        infoLabel.numberOfLines = 0
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: profileImageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        let dimension: CGFloat = 50
        dismissButton.setImage(UIImage(named: "dismiss_down_arrow"), for: .normal)
        dismissButton.addTarget(self, action:  #selector(handleTap), for: .touchUpInside)
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: profileImageView.bottomAnchor, leading: nil, bottom: nil, trailing: profileImageView.trailingAnchor, padding: .init(top: -dimension / 2, left: 0, bottom: 0, right: 24), size: .init(width: dimension, height: dimension))
    }
}


// MARK: - UIScrollViewDelegate
extension UserDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        let width = max(view.frame.width, view.frame.width + changeY * 2)
        let coordinate = min(0, -changeY)
        profileImageView.frame = CGRect(x: coordinate, y: coordinate, width: width, height: width)
    }
}
