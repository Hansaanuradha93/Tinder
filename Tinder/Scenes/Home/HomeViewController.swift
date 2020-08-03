import UIKit
import Firebase

class HomeViewController: UIViewController {

    // MARK: Properties
    fileprivate let topControllsStackView = HomeTopButtonControlsStackView()
    fileprivate let cardsDeckView = UIView()
    fileprivate let bottomControllsStackView = HomeBottomButtonControlsStackView()
    fileprivate let cardViewModel = CardViewModel()
    fileprivate var topCardView: CardView?
    fileprivate var previousCardView: CardView?
    fileprivate var matchedUser: User?
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupButtonActions()
        setupCardViewModelObserver()
        fetchData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pushToSignup()
    }
}


// MARK: - Objc Methods
extension HomeViewController {
    
    @objc fileprivate func settingsButtonTapped() {
        let controller = SettingsViewController()
        controller.delegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    
    @objc fileprivate func messageButtonTapped() {
        let controller = MatchMessagesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.currentUser = cardViewModel.currentUser
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc fileprivate func handleDislike() {
        saveSwipeToFirestore(isLiked: false)
        performSwipeAnimation(isLiked: false)
    }
    
    
    @objc fileprivate func handleLike() {
        saveSwipeToFirestore(isLiked: true)
        performSwipeAnimation(isLiked: true)
    }
    
    
    @objc fileprivate func handleRefresh() {
        cardsDeckView.subviews.forEach{ $0.removeFromSuperview() }
        fetchData()
    }
    
    
    @objc fileprivate func handleSendMessage() {
        guard let matchedUser = matchedUser else { return }
        navigateToChatLog(chatLogViewModel: matchedUser.toChatLogViewModel())
    }
}


// MARK: - Methods
extension HomeViewController {
    
    fileprivate func pushToSignup() {
        if Auth.auth().currentUser == nil {
            let controller = LoginViewController()
            controller.delegate = self
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .overFullScreen
            present(navigationController, animated: true)
        }
    }
    
    
    fileprivate func fetchData() {
        topCardView = nil
        cardViewModel.fetchCurrentUser { [weak self] user in
            guard let self = self, let user = user else { return }
            let cardView = self.setupCardFrom(user: user)
            self.previousCardView?.nextCardView = cardView
            self.previousCardView = cardView
            if self.topCardView == nil {
                self.topCardView = cardView
            }
        }
    }
    
    
    fileprivate func setupCardViewModelObserver() {
        cardViewModel.bindableIsFetchingUsers.bind { [weak self] isFetchingUsers in
            guard let self = self, let isFetchingUsers = isFetchingUsers else { return }
            if isFetchingUsers {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    fileprivate func setupButtonActions() {
        topControllsStackView.settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        topControllsStackView.messagesButton.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
        bottomControllsStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControllsStackView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControllsStackView.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
    }
    
    
    fileprivate func performSwipeAnimation(isLiked: Bool) {
        var translation: CGFloat = 1000
        var angle: CGFloat = 15

        if !isLiked {
            translation = -translation
            angle = -angle
        }
        
        let duration: Double = 5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
//        topCardView?.handleLike(isLiked: true)

        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
    }
    
    
    fileprivate func navigateToChatLog(chatLogViewModel: ChatLogViewModel) {
        chatLogViewModel.currentUser = cardViewModel.currentUser
        let controller = ChatLogViewController(chatLogViewModel: chatLogViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    fileprivate func saveSwipeToFirestore(isLiked: Bool) {
        cardViewModel.saveSwipe(isLiked: isLiked, cardView: topCardView) { [weak self] hasMatched, cardUID in
            guard let self = self else { return }
            if hasMatched {
                self.presentMatchView(cardUID: cardUID)
                self.saveMatchToFirestore(cardUID: cardUID)
            }
        }
    }
    
    
    fileprivate func saveMatchToFirestore(cardUID: String) {
        cardViewModel.saveMatchToFirestore(cardUID: cardUID)
    }
    
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = cardViewModel.currentUser
        matchView.delegate = self
        matchView.sendMessageButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    
    fileprivate func setupCardFrom(user: User) -> CardView {
        let cardView = CardView(cardViewModel: user.toCardViewModel())
        cardView.delegate = self
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    
    fileprivate func setupLayout() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        let overrallStackView = UIStackView(arrangedSubviews: [topControllsStackView, cardsDeckView, bottomControllsStackView])
        overrallStackView.axis = .vertical
        overrallStackView.isLayoutMarginsRelativeArrangement = true
        overrallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        overrallStackView.bringSubviewToFront(cardsDeckView)
        view.addSubview(overrallStackView)
        overrallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    
    fileprivate func clearCardDeckView() {
        cardsDeckView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    
    fileprivate func navigateToUserDetailsController(cardViewModel: CardViewModel) {
        let viewModel = UserDetailsViewModel(uid: cardViewModel.uid, imageUrls: cardViewModel.imageUrls, attributedText: cardViewModel.attributedText, currentUser: self.cardViewModel.currentUser)
        let controller = UserDetailsViewController()
        controller.delegate = self
        controller.setup(viewModel: viewModel)
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true)
    }
}


// MARK: - SettingsViewControllerDelegate
extension HomeViewController: SettingsViewControllerDelegete {
    
    func didSaveSettings() {
        clearCardDeckView()
        fetchData()
    }
}


// MARK: - LoginViewControllerDelegate
extension HomeViewController: LoginViewControllerDelegate {
    
    func didFinishLoggingIn() {
      fetchData()
    }
}


// MARK: - CardViewDelegate
extension HomeViewController: CardViewDelegate {
    
    func didTapCardViewBotton(cardViewModel: CardViewModel) {
        navigateToUserDetailsController(cardViewModel: cardViewModel)
    }
    
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        navigateToUserDetailsController(cardViewModel: cardViewModel)
    }
    
    
    func didRemove(cardView: CardView, isLiked: Bool) {
        saveSwipeToFirestore(isLiked: isLiked)
        topCardView?.removeFromSuperview()
        topCardView = self.topCardView?.nextCardView
    }
}


// MARK: - MatchViewDelegate
extension HomeViewController: MatchViewDelegate {
    
    func getMatchedUser(user: User) {
        self.matchedUser = user
    }
}


// MARK: - UserDetailsViewControllerDelegate
extension HomeViewController: UserDetailsViewControllerDelegate {
    
    func didTapLike(isLiked: Bool) {
        if isLiked {
            handleLike()
        } else {
            handleDislike()
        }
    }
}
