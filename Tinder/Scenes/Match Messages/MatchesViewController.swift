import UIKit

protocol MatchesDelegate {
    func tappedOn(match: Match)
}


class MatchesViewController: UICollectionViewController {
    
    // MARK: Properties
    var matchesDelegate: MatchesDelegate?

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
        return CGSize(width: 100, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 0)
    }
}


// MARK: - Collection View Delegate
extension MatchesViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        matchesDelegate?.tappedOn(match: matches[indexPath.item])
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
