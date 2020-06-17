import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subViews = [UIColor.gray, UIColor.darkGray, UIColor.black].map { color -> UIView in
            let view = UIView()
            view.backgroundColor = color
            return view
        }
        
        let redStackView = UIStackView(arrangedSubviews: subViews)
        redStackView.distribution = .fillEqually
        redStackView.axis = .horizontal
        redStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        
        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        yellowView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [redStackView, blueView, yellowView])
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        
        stackView.fillSuperview()
    }
}

