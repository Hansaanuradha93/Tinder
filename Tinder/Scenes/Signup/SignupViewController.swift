import UIKit

class SignupViewController: UIViewController {
    
    // MARK: Properties
    let profilePhotoButton = TDButton(backgroundColor: .white, title: "Select Photo", radius: 16, fontSize: 32)
    let fullNameTextField = TDTextField(padding: 16, placeholderText: "Enter full name", radius: 25)
    let emailTextField = TDTextField(padding: 16, placeholderText: "Enter email", radius: 25)
    let passwordTextField = TDTextField(padding: 16, placeholderText: "Enter password", radius: 25)
    let signupButton = TDButton(backgroundColor: UIColor.appColor(color: .darkPink), title: "Sign Up", titleColor: .white, radius: 25, fontSize: 24)

    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }
}


// MARK: - Methods
extension SignupViewController {
    
    fileprivate func layoutUI() {
        profilePhotoButton.heightAnchor.constraint(equalToConstant: 275).isActive = true
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [profilePhotoButton, fullNameTextField, emailTextField, passwordTextField, signupButton])
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
