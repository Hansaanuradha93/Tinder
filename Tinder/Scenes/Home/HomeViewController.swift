import UIKit
import Firebase

class HomeViewController: UIViewController {

    // MARK: Properties
    fileprivate let topControllsStackView = HomeTopButtonControlsStackView()
    fileprivate let cardsDeckView = UIView()
    fileprivate let bottomControllsStackView = HomeBottomButtonControlsStackView()
    fileprivate let cardViewModel = CardViewModel()
    
    
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
        cardViewModel.fetchCurrentUser { [weak self] user in
            guard let self = self, let user = user else { return }
            if user.uid != Auth.auth().currentUser?.uid {
                DispatchQueue.main.async { self.setupCardFrom(user: user) }
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
    
    
    fileprivate func setupButtonActions() {
        topControllsStackView.settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        bottomControllsStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
    }
    
    
    @objc fileprivate func handleRefresh() {
        fetchData()
    }
    
    
    fileprivate func setupCardFrom(user: User) {
        let cardView = CardView(cardViewModel: user.toCardViewModel())
        cardView.delegate = self
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    
    fileprivate func setupLayout() {
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
}

