import UIKit

class ViewController: UIViewController {

    let topStackView = HomeTopButtonControlsStackView()
    let blueView = UIView()
    let bottomStackView = HomeBottomButtonControlsStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}

// MARK: - Methods
extension ViewController {
    
    fileprivate func setupLayout() {
        
        blueView.backgroundColor = .blue
        
        let overrallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, bottomStackView])
        overrallStackView.axis = .vertical
        view.addSubview(overrallStackView)
        overrallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}

