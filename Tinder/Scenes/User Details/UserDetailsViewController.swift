import UIKit

class UserDetailsViewController: UIViewController {
    
    // MARK: Properties
    let scrollView = UIScrollView()
    let swipingPhotViewController = SwipingPhotosViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    let infoLabel = UILabel()
    lazy var swipingView = swipingPhotViewController.view!
    lazy var dismissButton = createButton(image: #imageLiteral(resourceName: "dismiss_down_arrow"), selector: #selector(handleTap))
    lazy var dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(handleDislike))
    lazy var superlikeButton = createButton(image: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(handleSuperlike))
    lazy var likeButton = createButton(image: #imageLiteral(resourceName: "like_circle"), selector: #selector(handlelike))

    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupVisualBlurEffectView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
    }
}


// MARK: - Methods
extension UserDetailsViewController {
    
    @objc fileprivate func handlelike() {
        // TODO: Handle like user
    }
    
    
    @objc fileprivate func handleSuperlike() {
        // TODO: Handle super like user
    }
    
    
    @objc fileprivate func handleDislike() {
        // TODO: Handle dislike user
    }
    
    
    @objc fileprivate func handleTap() {
        dismiss(animated: true)
    }
    
    
    func setup(cardViewModel: CardViewModel) {
        // TODO: Use userDetailsViewModel (viewModel for UserDetailsViewController) instead of cardViewModel
        infoLabel.attributedText = cardViewModel.attributedText
//        guard let firstImageUrl = cardViewModel.imageUrls.first else { return  }
//        profileImageView.downloadImage(from: firstImageUrl)
    }
    
    
    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
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
        scrollView.addSubview(swipingView)
        
        infoLabel.numberOfLines = 0
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: swipingView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        let dimension: CGFloat = 50
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: swipingView.trailingAnchor, padding: .init(top: -dimension / 2, left: 0, bottom: 0, right: 24), size: .init(width: dimension, height: dimension))
        
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superlikeButton, likeButton])
        stackView.distribution = .fillEqually
        scrollView.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, size: .init(width: 300, height: 100))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}


// MARK: - UIScrollViewDelegate
extension UserDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        let width = max(view.frame.width, view.frame.width + changeY * 2)
        let coordinate = min(0, -changeY)
        swipingView.frame = CGRect(x: coordinate, y: coordinate, width: width, height: width)
    }
}
