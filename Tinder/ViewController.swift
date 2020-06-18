import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subViews = [UIColor.gray, UIColor.darkGray, UIColor.black].map { color -> UIView in
            let view = UIView()
            view.backgroundColor = color
            return view
        }
        
        let topStackView = UIStackView(arrangedSubviews: subViews)
        topStackView.distribution = .fillEqually
        topStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        
        let bottomSubViews = [UIColor.purple, .cyan, .gray, .magenta].map { color -> UIView in
            let view = UIView()
            view.backgroundColor = color
            return view
        }
        
        let bottomStackView = UIStackView(arrangedSubviews: bottomSubViews)
        bottomStackView.distribution = .fillEqually
        bottomStackView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    
        let overrallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, bottomStackView])
        overrallStackView.axis = .vertical
        view.addSubview(overrallStackView)
        overrallStackView.fillSuperview()
    }
}

