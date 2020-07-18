import UIKit

class MatchesViewController: UICollectionViewController {
    
    // MARK: Properties
    fileprivate var matches = [Match]()
    fileprivate let matchesViewModel = MatchesViewModel()
    

    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMatches()
    }
}


// MARK: - Collection View Datasource
extension MatchesViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchCell.reuseID, for: indexPath) as! MatchCell
        cell.set(match: matches[indexPath.item])
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MatchesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}


// MARK: - Collection View Delegate
extension MatchesViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ChatLogViewController(match: matches[indexPath.item])
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - Methods
extension MatchesViewController {
    
    fileprivate func fetchMatches() {
        matchesViewModel.fetchMatches { [weak self] match in
            guard let self = self, let match = match else { return }
            self.matches.append(match)
            DispatchQueue.main.async { self.collectionView.reloadData() }
        }
    }
    
    fileprivate func setupUI() {
        collectionView.backgroundColor = .white
        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: MatchCell.reuseID)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
}
