import UIKit

class UserDetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}


// MARK: - Methods
extension UserDetailsViewController {
    
    @objc fileprivate func handleTap() {
        dismiss(animated: true)
    }
    
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(gesture)
    }
}
