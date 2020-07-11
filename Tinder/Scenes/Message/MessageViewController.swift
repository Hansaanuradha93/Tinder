import UIKit

class MessageViewController: UICollectionViewController {

    let customNavBar: UIView = {
        let navBar = UIView()
        navBar.backgroundColor = .blue
        return navBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
    }
}
