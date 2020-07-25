import UIKit

class MatchesViewController: UICollectionViewController {
    
    // MARK: Properties
    fileprivate let viewModel = MatchesViewModel()
    weak var rootMatchesController: MatchMessagesViewController?
    

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
        return viewModel.getMatchesCount()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchCell.reuseID, for: indexPath) as! MatchCell
        cell.set(match: viewModel.getMatchAt(indexPath))
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
        rootMatchesController?.didSelectMatchFromHeader(match: viewModel.getMatchAt(indexPath))
    }
}


// MARK: - Methods
extension MatchesViewController {
    
    fileprivate func fetchMatches() {
        viewModel.fetchMatches { [weak self] status in
            guard let self = self else { return }
            if status { DispatchQueue.main.async { self.collectionView.reloadData() } }
        }
    }
    
    
    fileprivate func setupUI() {
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: MatchCell.reuseID)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
}
