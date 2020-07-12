import UIKit

class ChatLogNavigationBar: UIView {
    
    // MARK: Properties
    fileprivate let profileImageView = TDImageView(image: #imageLiteral(resourceName: "jane1"), contentMode: .scaleAspectFill)
    fileprivate let usernameLabel = TDLabel(text: "Username", textAlignment: .center, textColor: .gray, fontSize: 14, numberOfLines: 2)
    let backButton = TDButton(type: .system)
    let flagButton = TDButton(type: .system)

    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension ChatLogNavigationBar {
    
    fileprivate func setupUI() {
        backgroundColor = .white
        dropShadow(color: UIColor.black, opacity: 0.05, offset: CGSize(width: 0, height: 10), radius: 8)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(backButton)
        addSubview(flagButton)
        
        let dimensions: CGFloat = 50
        profileImageView.layer.cornerRadius = dimensions / 2
        profileImageView.centerInSuperview(size: .init(width: dimensions, height: dimensions))
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        usernameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        backButton.setImage(Asserts.back, for: .normal)
        backButton.imageView?.image = backButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
        backButton.tintColor = UIColor.appColor(color: .pink)
        backButton.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: dimensions, height: dimensions))
        backButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        flagButton.setImage(Asserts.flag, for: .normal)
        flagButton.imageView?.image = flagButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
        flagButton.tintColor = UIColor.appColor(color: .pink)
        flagButton.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: dimensions, height: dimensions))
        flagButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
