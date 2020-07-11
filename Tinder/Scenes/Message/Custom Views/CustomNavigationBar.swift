import UIKit

class CustomNavigationBar: UIView {
    
    fileprivate let iconImageView = TDImageView(image: Asserts.topMessages, contentMode: .scaleAspectFit)
    fileprivate let messagesLabel = TDLabel(text: "Messages", textAlignment: .center, textColor: UIColor.appColor(color: .pink), fontSize: 20)
    fileprivate let feedLabel = TDLabel(text: "Feed", textAlignment: .center, textColor: .gray, fontSize: 20)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dropShadow(color: UIColor.black, opacity: 0.05, offset: CGSize(width: 0, height: 10), radius: 8)
    }
}


// MARK: Methods
extension CustomNavigationBar {
    
    fileprivate func setupUI() {
        backgroundColor = .white
        
        iconImageView.image = iconImageView.image?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = UIColor.appColor(color: .pink)
        iconImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [messagesLabel, feedLabel])
        stackView.distribution = .fillEqually
        
        let overrallStackView = UIStackView(arrangedSubviews: [iconImageView, stackView])
        overrallStackView.axis = .vertical
        addSubview(overrallStackView)
        overrallStackView.fillSuperview()
    }
}
