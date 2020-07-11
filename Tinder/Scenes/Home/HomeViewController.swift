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
    
    
    @objc fileprivate func settingsButtonTapped() {
        let controller = SettingsViewController()
        controller.delegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    
    @objc fileprivate func messageButtonTapped() {
        let controller = MessageViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    fileprivate func setupButtonActions() {
        topControllsStackView.settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        topControllsStackView.messagesButton.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
        bottomControllsStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControllsStackView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControllsStackView.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
    }
    
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration: Double = 0.7
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
    }
    
    
    @objc fileprivate func handleDislike() {
        saveSwipeToFirestore(isLiked: false)
        performSwipeAnimation(translation: -1000, angle: -15)
    }
    
    
    @objc fileprivate func handleLike() {
        saveSwipeToFirestore(isLiked: true)
        performSwipeAnimation(translation: 1000, angle: 15)
    }
    
    
    @objc fileprivate func handleRefresh() {
        cardsDeckView.subviews.forEach{ $0.removeFromSuperview() }
        fetchData()
    }
    
    
    fileprivate func saveSwipeToFirestore(isLiked: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Firestore.firestore().collection("swipes").document(uid)
        
        guard let cardUID = topCardView?.cardViewModel.uid else { return }
        if isLiked { self.checkIfMatchExist(cardUID: cardUID) }

        let value = isLiked ? 1 : 0
        let documentData = [cardUID: value]
        
        reference.getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if snapshot?.exists ?? false {
                reference.updateData(documentData) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("Swipe successfully updated")
                }
            } else {
                reference.setData(documentData) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("Swipe successfully saved")
                }
            }
        }
    }
    
    
    fileprivate func checkIfMatchExist(cardUID: String) {
        let reference = Firestore.firestore().collection("swipes").document(cardUID)
        reference.getDocument { [weak self] snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let self = self, let data = snapshot?.data(), let uid = Auth.auth().currentUser?.uid else { return }
            
            let hasMatched = data[uid] as? Int == 1
            if hasMatched {
                self.presentMatchView(cardUID: cardUID)
            }
        }
    }
    
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = cardViewModel.currentUser
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
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let controller = UserDetailsViewController()
        controller.setup(cardViewModel: cardViewModel)
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true)
    }
    
    
    func didRemove(cardView: CardView, isLiked: Bool) {
        saveSwipeToFirestore(isLiked: isLiked)
        topCardView?.removeFromSuperview()
        topCardView = self.topCardView?.nextCardView
    }
}

