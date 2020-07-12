import UIKit

class ChatLogViewController: UICollectionViewController {

    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
}


// MARK: - Collection View Data Source
extension ChatLogViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}


// MARK: - Methods
extension ChatLogViewController {
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}
