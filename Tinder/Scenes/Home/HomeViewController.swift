import UIKit
import Firebase

class HomeViewController: UIViewController {

    // MARK: Properties
    let topStackView = HomeTopButtonControlsStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomButtonControlsStackView()
    
    var cardViewModels = [CardViewModel]()
    var lastFetchedUser: User?
    
    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupFirestoreUserCards()
        setupButtonActions()
        fetchUsersFromFirestore()
    }
}

// MARK: - Methods
extension HomeViewController {
    
    fileprivate func fetchUsersFromFirestore() {
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            snapshot!.documents.forEach { (documentSnapshot) in
                let user = User(dictionary: documentSnapshot.data())
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
            }
            self.setupFirestoreUserCards()
        }
    }
    
    @objc fileprivate func settingsButtonTapped() {
        let controller = SignupViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    
    fileprivate func setupButtonActions() {
        topStackView.settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    }
    
    
    fileprivate func setupFirestoreUserCards() {
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView(cardViewModel: cardViewModel)
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        
        let overrallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
        overrallStackView.axis = .vertical
        overrallStackView.isLayoutMarginsRelativeArrangement = true
        overrallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        overrallStackView.bringSubviewToFront(cardsDeckView)
        
        view.addSubview(overrallStackView)
        overrallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}

