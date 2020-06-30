import UIKit

protocol LoginControllerDelegate {
    func didFinishLoggingIn()
}


class LoginViewController: UIViewController {
    
    // MARK: Properties
    fileprivate let emailTextField = TDTextField(padding: 24, placeholderText: "Enter email", radius: 25)
    fileprivate let passwordTextField = TDTextField(padding: 24, placeholderText: "Enter password", radius: 25)
    fileprivate let loginButton = TDButton(backgroundColor: UIColor.appColor(color: .lightGray), title: "Login", titleColor: .gray, radius: 25, fontSize: 24)
    fileprivate let backToRegisterButton = TDButton(backgroundColor: .clear, title: "Go back", titleColor: .white, radius: 0, fontSize: 18)

    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    fileprivate let loginViewModel = LoginViewModel()
    var delegate: LoginControllerDelegate?
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindables()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }
}


// MARK: - Methods
extension LoginViewController {
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    
    
    @objc fileprivate func handleLogin() {
        loginViewModel.performLogin { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlert(title: "Login Failed", message: error.localizedDescription, buttonTitle: "Ok")
                return
            }
            
            print("Logged in successfully")
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishLoggingIn()
            })
        }
    }
    
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    
    fileprivate func setupBindables() {
        loginViewModel.isFormValid.bind { [weak self] (isFormValid) in
            guard let self = self, let isFormValid = isFormValid else { return }
            if isFormValid {
                self.loginButton.backgroundColor = UIColor.appColor(color: .darkPink)
                self.loginButton.setTitleColor(.white, for: .normal)
            } else {
                self.loginButton.backgroundColor = UIColor.appColor(color: .lightGray)
                self.loginButton.setTitleColor(.gray, for: .disabled)
            }
            self.loginButton.isEnabled = isFormValid
        }
        loginViewModel.isLoggingIn.bind { [weak self] isLogin in
            guard let self = self, let isLogin = isLogin else { return }
            if isLogin {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    fileprivate func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.appColor(color: .orange).cgColor, UIColor.appColor(color: .pink).cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.isEnabled = false
        emailTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        backToRegisterButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        view.addSubview(backToRegisterButton)
        backToRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}
