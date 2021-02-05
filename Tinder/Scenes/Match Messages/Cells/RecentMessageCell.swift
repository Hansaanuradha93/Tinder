import UIKit

class RecentMessageCell: UICollectionViewCell {
    
    // MARK: Properties
    static let reuseID = "RecentMessageCell"
    
    private let profileImageView = TDImageView()
    private let usernameLabel = TDLabel(textAlignment: .left, fontSize: 16)
    private let messageLabel = TDLabel(textAlignment: .left, textColor: .gray, fontSize: 14, numberOfLines: 2)
    private let barView = UIView()
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension RecentMessageCell {
    
    func set(recentMessage: RecentMessage) {
        profileImageView.downloadImage(from: recentMessage.profileImageUrl ?? "")
        usernameLabel.text = recentMessage.name ?? ""
        messageLabel.text = recentMessage.text ?? ""
    }
    
    
    private func setupUI() {
        let dimensions: CGFloat = 100
        let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 20)
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.layer.cornerRadius = dimensions / 2
        profileImageView.alignLeadingInSuperView(leading: leadingAnchor, paddingLeading: 16)
        profileImageView.centerVerticallyInSuperView(size: .init(width: dimensions, height: dimensions))
        
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, messageLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        addSubview(stackView)
        stackView.anchor(top: nil, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: padding)
        stackView.centerVerticallyInSuperView()
        
        barView.backgroundColor = UIColor.appColor(color: .regularGray)
        addSubview(barView)
        barView.anchor(top: nil, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: padding, size: .init(width: 0, height: 1))
    }
}
