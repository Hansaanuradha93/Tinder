import UIKit

class SignupViewController: UIViewController {
    
    // MARK: Properties
    let profilePhotoButton = TDButton(backgroundColor: .white, title: "Select Photo", radius: 16, fontSize: 32)
    let fullNameTextField = TDTextField(padding: 16, placeholderText: "Enter full name", radius: 16)
    let emailTextField = TDTextField(padding: 16, placeholderText: "Enter email", radius: 16)
    let passwordTextField = TDTextField(padding: 16, placeholderText: "Enter password", radius: 16)

    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
}


// MARK: - Methods
extension SignupViewController {
    
    fileprivate func layoutUI() {
        view.backgroundColor = .red

        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        profilePhotoButton.heightAnchor.constraint(equalToConstant: 275).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [profilePhotoButton, fullNameTextField, emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubview(stackView)
        stackView.centerInSuperview()
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
    }
}
