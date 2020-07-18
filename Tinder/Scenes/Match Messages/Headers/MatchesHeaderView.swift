import UIKit

protocol MatchesHeaderViewDelegate {
    func tappedOn(match: Match)
}


class MatchesHeaderView: UICollectionReusableView {
     
    // MARK: Properties
    static let reuseID = "MatchesHeaderView"
    var delegate: MatchesHeaderViewDelegate?

    let newMatchesLabel = TDLabel(text: "New Matches", textAlignment: .left, textColor: UIColor.appColor(color: .pink), fontSize: 18)
    let matchesController = MatchesViewController(collectionViewLayout: UICollectionViewFlowLayout())
    let messagesLabel = TDLabel(text: "Messages", textAlignment: .left, textColor: UIColor.appColor(color: .pink), fontSize: 18)
    
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
        matchesController.matchesDelegate = self
        
        let matchStackView = UIStackView(arrangedSubviews: [newMatchesLabel])
        matchStackView.isLayoutMarginsRelativeArrangement = true
        matchStackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        let messagesStackView = UIStackView(arrangedSubviews: [messagesLabel])
        messagesStackView.isLayoutMarginsRelativeArrangement = true
        messagesStackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        let stackView = UIStackView(arrangedSubviews: [matchStackView, matchesController.view, messagesStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
}


// MARK: - MatchesDelegate
extension MatchesHeaderView: MatchesDelegate {
    func tappedOn(match: Match) {
        delegate?.tappedOn(match: match)
    }
}
