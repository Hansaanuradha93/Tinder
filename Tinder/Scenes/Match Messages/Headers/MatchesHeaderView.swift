import UIKit

class MatchesHeaderView: UICollectionReusableView {
     
    // MARK: Properties
    static let reuseID = "MatchesHeaderView"
    let newMatchesLabel = TDLabel(text: "New Matches", textAlignment: .left, textColor: UIColor.appColor(color: .pink), fontSize: 16)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let messagesLabel = TDLabel(text: "Messages", textAlignment: .left, textColor: UIColor.appColor(color: .pink), fontSize: 16)
    
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
        backgroundColor = .white
        collectionView.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [newMatchesLabel, collectionView, messagesLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 0, right: 0))
    }
}
