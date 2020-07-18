import UIKit

class MatchesHeaderView: UICollectionReusableView {
     
    // MARK: Properties
    static let reuseID = "MatchesHeaderView"
    
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK - Methods
extension MatchesHeaderView {
    
    fileprivate func setupUI() {
        backgroundColor = .red
    }
}
