import UIKit
import Firebase

class HomeViewController: UIViewController {

    // MARK: Properties
    private let topControllsStackView = HomeTopButtonControlsStackView()
    private let cardsDeckView = UIView()
    private let bottomControllsStackView = HomeBottomButtonControlsStackView()
    private let cardViewModel = CardViewModel()
    private var topCardView: CardView?
    private var previousCardView: CardView?
    private var matchedUser: User?
    
    
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
private extension HomeViewController {
    
    @objc func settingsButtonTapped() {
        let controller = SettingsViewController()
        controller.delegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    
    @objc func messageButtonTapped() {
        let controller = MatchMessagesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.currentUser = cardViewModel.currentUser
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func handleDislike() {
        saveSwipeToFirestore(isLiked: false)
        performSwipeAnimation(isLiked: false)
    }
    
    
    @objc func handleLike() {
        saveSwipeToFirestore(isLiked: true)
        performSwipeAnimation(isLiked: true)
    }
    
    
    @objc func handleRefresh() {
        cardsDeckView.subviews.forEach{ $0.removeFromSuperview() }
        fetchData()
    }
    
    
    @objc func handleSendMessage() {
        guard let matchedUser = matchedUser else { return }
        navigateToChatLog(chatLogViewModel: matchedUser.toChatLogViewModel())
    }
}


// MARK: - Methods
private extension HomeViewController {
    
    func pushToSignup() {
        if Auth.auth().currentUser == nil {
            let controller = SignupViewController()
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .overFullScreen
            present(navigationController, animated: true)
        }
    }
    
    
    func fetchData() {
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
    
    
    func setupCardViewModelObserver() {
        cardViewModel.bindableIsFetchingUsers.bind { [weak self] isFetchingUsers in
            guard let self = self, let isFetchingUsers = isFetchingUsers else { return }
            if isFetchingUsers {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    func setupButtonActions() {
        topControllsStackView.settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        topControllsStackView.messagesButton.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
        bottomControllsStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControllsStackView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControllsStackView.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
    }
    
    
    func performSwipeAnimation(isLiked: Bool) {
        topCardView = topCardView?.performSwipeAnimation(isLiked: isLiked)
    }
    
    
    func navigateToChatLog(chatLogViewModel: ChatLogViewModel) {
        chatLogViewModel.currentUser = cardViewModel.currentUser
        let controller = ChatLogViewController(chatLogViewModel: chatLogViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func saveSwipeToFirestore(isLiked: Bool) {
        cardViewModel.saveSwipe(isLiked: isLiked, cardView: topCardView) { [weak self] hasMatched, cardUID in
            guard let self = self else { return }
            if hasMatched {
                self.presentMatchView(cardUID: cardUID)
                self.cardViewModel.saveMatchToFirestore(cardUID: cardUID)
            }
        }
    }
    
    
    func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = cardViewModel.currentUser
        matchView.delegate = self
        matchView.sendMessageButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    
    func setupCardFrom(user: User) -> CardView {
        let cardView = CardView(cardViewModel: user.toCardViewModel())
        cardView.delegate = self
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    
    func setupLayout() {
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
    
    
    func clearCardDeckView() {
        cardsDeckView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    
    func navigateToUserDetailsController(cardViewModel: CardViewModel) {
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
