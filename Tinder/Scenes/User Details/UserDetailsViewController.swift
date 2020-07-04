import UIKit

class UserDetailsViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let profileImageView = UIImageView()
    let infoLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}


// MARK: - Methods
extension UserDetailsViewController {
    
    @objc fileprivate func handleTap() {
        dismiss(animated: true)
    }
    
    
    func setup(cardViewModel: CardViewModel) {
//        profileImageView.downloadImage(from: <#T##String#>)
        infoLabel.attributedText = cardViewModel.attributedText
    }
    
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        profileImageView.image = #imageLiteral(resourceName: "kelly1").withRenderingMode(.alwaysOriginal)
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        scrollView.addSubview(profileImageView)
        profileImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        infoLabel.numberOfLines = 0
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: profileImageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(gesture)
    }
}


// MARK: - UIScrollViewDelegate
extension UserDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        let width = max(view.frame.width, view.frame.width + changeY * 2)
        let coordinate = min(0, -changeY)
        profileImageView.frame = CGRect(x: coordinate, y: coordinate, width: width, height: width)
    }
}
