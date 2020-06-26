import UIKit
import Firebase

class HomeViewController: UIViewController {

    // MARK: Properties
    let topControllsStackView = HomeTopButtonControlsStackView()
    let cardsDeckView = UIView()
    let bottomControllsStackView = HomeBottomButtonControlsStackView()
    
    var cardViewModels = [CardViewModel]()
    var lastFetchedUser: User?
    
    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupButtonActions()
        fetchUsersFromFirestore()
    }
}

// MARK: - Methods
extension HomeViewController {
    
    fileprivate func fetchUsersFromFirestore() {
        self.showPreloader()
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 3)
        query.getDocuments { (snapshot, error) in
            self.hidePreloader()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            snapshot!.documents.forEach { (documentSnapshot) in
                let user = User(dictionary: documentSnapshot.data())
                self.lastFetchedUser = user
                DispatchQueue.main.async { self.setupCardFrom(user: user) }
            }
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
        fetchUsersFromFirestore()
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

