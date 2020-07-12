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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseID, for: indexPath) as! MessageCell
        cell.backgroundColor = .blue
        return cell
    }
}


// MARK: - Methods
extension ChatLogViewController {
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseID)
    }
}
