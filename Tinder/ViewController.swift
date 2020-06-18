import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topStackView = HomeTopButtonControlsStackView()
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        
        let bottomStackView = HomeBottomButtonControlsStackView()
        
        let overrallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, bottomStackView])
        overrallStackView.axis = .vertical
        view.addSubview(overrallStackView)
        overrallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}

