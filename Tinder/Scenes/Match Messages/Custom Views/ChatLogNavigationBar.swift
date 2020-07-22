import UIKit

class ChatLogNavigationBar: UIView {
    
    // MARK: Properties
    fileprivate var chatLogViewModel: ChatLogViewModel!
    fileprivate let dimensions: CGFloat = 50
    fileprivate let profileImageView = TDImageView(contentMode: .scaleAspectFill)
    fileprivate let usernameLabel = TDLabel( textAlignment: .center, textColor: .gray, fontSize: 16, numberOfLines: 2)
    fileprivate lazy var views = [profileImageView, usernameLabel, backButton, flagButton]
    let backButton = TDButton(type: .system)
    let flagButton = TDButton(type: .system)

    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    convenience init(chatLogViewModel: ChatLogViewModel) {
        self.init(frame: .zero)
        self.chatLogViewModel = chatLogViewModel
        setupUser()
    }
}


// MARK: - Methods
extension ChatLogNavigationBar {
    
    fileprivate func setupUser() {
        profileImageView.downloadImage(from: chatLogViewModel.profileImageUrl)
        usernameLabel.text = chatLogViewModel.username
    }
    
    
    fileprivate func setupUI() {
        backgroundColor = .white
        dropShadow(color: UIColor.black, opacity: 0.05, offset: CGSize(width: 0, height: 10), radius: 8)
        views.forEach{ addSubview($0) }
        
        profileImageView.layer.cornerRadius = dimensions / 2
        profileImageView.centerInSuperview(size: .init(width: dimensions, height: dimensions))
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        usernameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        backButton.set(image: Asserts.back, withTint: UIColor.appColor(color: .pink))
        backButton.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: dimensions, height: dimensions))
        backButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        flagButton.set(image: Asserts.flag, withTint: UIColor.appColor(color: .pink))
        flagButton.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: dimensions, height: dimensions))
        flagButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
