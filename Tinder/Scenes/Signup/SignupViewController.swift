import UIKit

class SignupViewController: UIViewController {

    var profilePhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Select Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    let fullNameTextField = TDTextField(padding: 16, placeholderText: "Enter full name", radius: 16)
    let emailTextField = TDTextField(padding: 16, placeholderText: "Enter email", radius: 16)
    let passwordTextField = TDTextField(padding: 16, placeholderText: "Enter password", radius: 16)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
    
    
    fileprivate func layoutUI() {
        view.backgroundColor = .red

        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        
        let stackView = UIStackView(arrangedSubviews: [profilePhotoButton, fullNameTextField, emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        
        stackView.centerInSuperview()
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))

    }
}
