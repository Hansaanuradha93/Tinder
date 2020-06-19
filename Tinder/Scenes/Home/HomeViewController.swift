import UIKit

class HomeViewController: UIViewController {

    let topStackView = HomeTopButtonControlsStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomButtonControlsStackView()
    
    let users = [
        User(name: "Kelly", age: 23, profession: "DJ Music", imageUrl: "lady4c"),
        User(name: "Jane", age: 18, profession: "Teacher", imageUrl: "lady5c")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
    }
}

// MARK: - Methods
extension HomeViewController {
    
    fileprivate func setupDummyCards() {
        
        users.forEach { (user) in
            let cardView = CardView()
            cardView.imageView.image = UIImage(named: user.imageUrl)
            cardView.informationLabel.text = "\(user.name) \(user.age)\n\(user.profession)"
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
                
        let overrallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
        overrallStackView.axis = .vertical
        
        view.addSubview(overrallStackView)
        overrallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overrallStackView.isLayoutMarginsRelativeArrangement = true
        overrallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        overrallStackView.bringSubviewToFront(cardsDeckView)
    }
}

