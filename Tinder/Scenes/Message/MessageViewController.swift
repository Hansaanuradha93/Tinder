import UIKit

class MessageViewController: UICollectionViewController {

    // MARK: Properties
    let customNavBar = CustomNavigationBar()
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
    }
}


// MARK: - Collection View Datasource
extension MessageViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchCell.reuseID, for: indexPath) as! MatchCell
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MessageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}


// MARK: - Methods
extension MessageViewController {
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = 130
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseID)
        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: MatchCell.reuseID)
    }
    
    
    fileprivate func setupLayout() {
        navigationController?.navigationBar.isHidden = true

        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 130))
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
}
