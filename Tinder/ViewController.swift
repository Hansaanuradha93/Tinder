import UIKit

class ViewController: UIViewController {

    let topStackView = HomeTopButtonControlsStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomButtonControlsStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
    }
}

// MARK: - Methods
extension ViewController {
    
    fileprivate func setupDummyCards() {
        
        let cardView = CardView(frame: .zero)
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    fileprivate func setupLayout() {
        
        cardsDeckView.backgroundColor = .blue
        
        let overrallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
        overrallStackView.axis = .vertical
        view.addSubview(overrallStackView)
        overrallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}

