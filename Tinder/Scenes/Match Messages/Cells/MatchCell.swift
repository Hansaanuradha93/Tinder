import UIKit

class MatchCell: UICollectionViewCell {
    
    // MARK: Properties
    static let reuseID = "MatchCell"
    
    private let profileImageView = TDImageView(contentMode: .scaleAspectFill)
    private let usernameLabel = TDLabel(textColor: .gray, fontSize: 14, numberOfLines: 2)
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension MatchCell {
    
    func set(match: Match) {
        profileImageView.downloadImage(from: match.profileImageUrl ?? "")
        usernameLabel.text = match.username ?? ""
    }
    
    
    private func setupLayout() {
        let dimenstions = frame.width
        profileImageView.setHeight(dimenstions)
        profileImageView.layer.cornerRadius = dimenstions / 2
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView, usernameLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        addSubview(stackView)
        stackView.fillSuperview()
    }
}
