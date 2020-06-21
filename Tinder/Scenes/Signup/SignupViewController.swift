import UIKit

class SignupViewController: UIViewController {
    
    // MARK: Properties
    let profilePhotoButton = TDButton(backgroundColor: .white, title: "Select Photo", radius: 16, fontSize: 32)
    let fullNameTextField = TDTextField(padding: 16, placeholderText: "Enter full name", radius: 25)
    let emailTextField = TDTextField(padding: 16, placeholderText: "Enter email", radius: 25)
    let passwordTextField = TDTextField(padding: 16, placeholderText: "Enter password", radius: 25)
    let signupButton = TDButton(backgroundColor: UIColor.appColor(color: .darkPink), title: "Sign Up", titleColor: .white, radius: 25, fontSize: 24)
    lazy var stackView = UIStackView(arrangedSubviews: [profilePhotoButton, fullNameTextField, emailTextField, passwordTextField, signupButton])

    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        setupNotifications()
        handleTapGesture()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - Methods
extension SignupViewController {
    
    fileprivate func handleTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc fileprivate func handleTap() {
        view.endEditing(true)
    }
    
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -(difference + 10))
    }
    
    
    fileprivate func layoutUI() {
        profilePhotoButton.heightAnchor.constraint(equalToConstant: 275).isActive = true
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubview(stackView)
        stackView.centerInSuperview()
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
    }
    
    
    fileprivate func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.appColor(color: .orange).cgColor, UIColor.appColor(color: .pink).cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
