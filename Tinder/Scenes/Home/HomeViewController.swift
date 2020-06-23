import UIKit
import Firebase

class HomeViewController: UIViewController {

    // MARK: Properties
    let topStackView = HomeTopButtonControlsStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomButtonControlsStackView()
    
    let cardViewModels: [CardViewModel] = {
        let producers = [
            User(name: "Kelly", age: 23, profession: "DJ Music", imageUrls: ["kelly1", "kelly2", "kelly3"]),
            User(name: "Jane", age: 18, profession: "Teacher", imageUrls: ["jane1", "jane2", "jane3"]),
            Advertiser(title: "Slide Out Menu", brandName: "Lets Build That App", posterImageUrl: "slide_out_menu_poster")
            ] as [ProducesCardViewModel]
        
        let viewModels = producers.map{ return $0.toCardViewModel()}
        return viewModels
    }()
    
    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
        setupButtonActions()
        fetchUsersFromFirestore()
    }
}

// MARK: - Methods
extension HomeViewController {
    
    fileprivate func fetchUsersFromFirestore() {
        Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            snapshot!.documents.forEach { (documentSnapshot) in
                let user = User(dictionary: documentSnapshot.data())
                print("\(user)")
            }
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
    
    
    fileprivate func setupDummyCards() {
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

