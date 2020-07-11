import UIKit

class MessageViewController: UICollectionViewController {

    // MARK: Properties
    let customNavBar = CustomNavigationBar()
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}


// MARK: - Methods
extension MessageViewController {
    
    fileprivate func setupLayout() {
        navigationController?.navigationBar.isHidden = true
        collectionView.backgroundColor = .white

        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 130))
    }
}
