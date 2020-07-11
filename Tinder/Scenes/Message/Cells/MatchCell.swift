import UIKit

class MatchCell: UICollectionViewCell {
    
    // MARK: Properties
    static let reuseID = "MatchCell"
    fileprivate let profileImageView = TDImageView(image: #imageLiteral(resourceName: "jane3"), contentMode: .scaleAspectFill)
    fileprivate let usernameLabel = TDLabel(text: "Username", textAlignment: .center, textColor: UIColor.gray, fontSize: 14)
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension MatchCell {
    
    fileprivate func setupLayout() {
        let dimenstions = frame.width
        profileImageView.widthAnchor.constraint(equalToConstant: dimenstions).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: dimenstions).isActive = true
        profileImageView.layer.cornerRadius = dimenstions / 2
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView, usernameLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        addSubview(stackView)
        stackView.fillSuperview()
    }
}
