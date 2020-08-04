import UIKit

protocol LoginViewControllerDelegate {
    func didFinishLoggingIn()
}


class LoginViewController: UIViewController {
    
    // MARK: Properties
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let emailTextField = TDTextField(padding: 24, placeholderText: Strings.enterEmail, radius: 25)
    fileprivate let passwordTextField = TDTextField(padding: 24, placeholderText: Strings.enterPassword, radius: 25)
    fileprivate let loginButton = TDButton(backgroundColor: UIColor.appColor(color: .lightGray), title: Strings.login, titleColor: .gray, radius: 25, fontSize: 24)
    fileprivate let backToRegisterButton = TDButton(backgroundColor: .clear, title: Strings.goBack, titleColor: .white, radius: 0, fontSize: 18)

    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    fileprivate let viewModel = LoginViewModel()
    var delegate: LoginViewControllerDelegate?
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupLayout()
        addTargets()
        setupBindables()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
}


// MARK: - Objc Methods
extension LoginViewController {
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            viewModel.email = textField.text
        } else {
            viewModel.password = textField.text
        }
    }
    
    
    @objc fileprivate func handleLogin() {
        viewModel.performLogin { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlert(title: Strings.loginFailed, message: error.localizedDescription, buttonTitle: Strings.ok)
                return
            }
            
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishLoggingIn()
            })
        }
    }
    
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - Methods
extension LoginViewController {

    fileprivate func setupBindables() {
        viewModel.isFormValid.bind { [weak self] (isFormValid) in
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
        viewModel.isLoggingIn.bind { [weak self] isLogin in
            guard let self = self, let isLogin = isLogin else { return }
            if isLogin {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    fileprivate func setupGradient() {
        gradientLayer.colors = [UIColor.appColor(color: .orange).cgColor, UIColor.appColor(color: .pink).cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    fileprivate func setupLayout() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.isEnabled = false
        
        view.addSubview(backToRegisterButton)
        backToRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    
    fileprivate func addTargets() {
        emailTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        backToRegisterButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
}
