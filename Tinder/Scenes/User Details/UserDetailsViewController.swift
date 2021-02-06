import UIKit

protocol UserDetailsViewControllerDelegate {
    func didTapLike(isLiked: Bool)
}


class UserDetailsViewController: UIViewController {
    
    // MARK: Properties
    fileprivate let scrollView = UIScrollView()
    fileprivate let swipingPhotViewController = SwipingPhotosViewController()
    fileprivate let infoLabel = UILabel()
    fileprivate var viewModel: UserDetailsViewModel!
    fileprivate var matchedUser: User?
    fileprivate lazy var swipingView = swipingPhotViewController.view!
    fileprivate lazy var dismissButton = createButton(image: Asserts.dismissDownArrow, selector: #selector(handleTap))
    fileprivate lazy var dislikeButton = createButton(image: Asserts.dismissCircle, selector: #selector(handleDislike))
    fileprivate lazy var superlikeButton = createButton(image: Asserts.superLike, selector: #selector(handleSuperlike))
    fileprivate lazy var likeButton = createButton(image: Asserts.like, selector: #selector(handlelike))
    fileprivate lazy var extraSwipingHeight: CGFloat = 100
    var delegate: UserDetailsViewControllerDelegate?
   
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupVisualBlurEffectView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraSwipingHeight)
    }
}


// MARK: - Objc Methods
private extension UserDetailsViewController {
    
    @objc func handlelike() {
        dismiss(animated: true) { self.delegate?.didTapLike(isLiked: true) }
    }
    
    
    @objc func handleSuperlike() {
        // TODO: Handle super like user
    }
    
    
    @objc func handleDislike() {
        dismiss(animated: true) { self.delegate?.didTapLike(isLiked: false) }
    }
    
    
    @objc func handleTap() {
        dismiss(animated: true)
    }
    
    
    @objc func handleSendMessage() {
        guard let matchedUser = matchedUser else { return }
        navigateToChatLog(chatLogViewModel: matchedUser.toChatLogViewModel())
    }
}


// MARK: - Methods
extension UserDetailsViewController {
    
    func setup(viewModel: UserDetailsViewModel) {
        self.viewModel = viewModel
        infoLabel.attributedText = viewModel.attributedText
        swipingPhotViewController.imageUrls = viewModel.imageUrls
    }
    
    
    private func navigateToChatLog(chatLogViewModel: ChatLogViewModel) {
        chatLogViewModel.currentUser = viewModel.currentUser
        let controller = ChatLogViewController(chatLogViewModel: chatLogViewModel)
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true)
    }
    
    
    private func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    
    private func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    
    private func setupLayout() {
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
        swipingView.frame = CGRect(x: coordinate, y: coordinate, width: width, height: width + extraSwipingHeight)
    }
}
