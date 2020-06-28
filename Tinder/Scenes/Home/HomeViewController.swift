import UIKit
import Firebase

class HomeViewController: UIViewController {

    // MARK: Properties
    let topControllsStackView = HomeTopButtonControlsStackView()
    let cardsDeckView = UIView()
    let bottomControllsStackView = HomeBottomButtonControlsStackView()
    let cardViewModel = CardViewModel()
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupButtonActions()
        setupCardViewModelObserver()
        fetchUsers()
    }
}

// MARK: - Methods
extension HomeViewController {
    
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
    
    
    fileprivate func fetchUsers() {
        cardViewModel.fetchUsersFromFirestore { [weak self] user in
            guard let self = self, let user = user else { return }
            DispatchQueue.main.async { self.setupCardFrom(user: user) }
        }
    }
    
    
    @objc fileprivate func settingsButtonTapped() {
        let navigationController = UINavigationController(rootViewController: SettingsViewController())
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    
    fileprivate func setupButtonActions() {
        topControllsStackView.settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        bottomControllsStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
    }
    
    
    @objc fileprivate func handleRefresh() {
        fetchUsers()
    }
    
    
    fileprivate func setupCardFrom(user: User) {
        let cardView = CardView(cardViewModel: user.toCardViewModel())
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
}

