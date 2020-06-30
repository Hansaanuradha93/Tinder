import UIKit

protocol LoginControllerDelegate {
    func didFinishLoggingIn()
}

class LoginViewController: UIViewController {
    
    let emailTextField = TDTextField(padding: 24, placeholderText: "Enter email", radius: 25)
    let passwordTextField = TDTextField(padding: 24, placeholderText: "Enter password", radius: 25)
    let loginButton = TDButton(backgroundColor: UIColor.appColor(color: .lightGray), title: "Login", titleColor: .gray, radius: 25, fontSize: 24)
    
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    var delegate: LoginControllerDelegate?

    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    
//    let loginButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Login", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
//        button.backgroundColor = .lightGray
//        button.setTitleColor(.gray, for: .disabled)
//        button.isEnabled = false
//        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        button.layer.cornerRadius = 22
//        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
//        return button
//    }()
    
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
    
    fileprivate let backToRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
        setupBindables()
    }
    
    fileprivate let loginViewModel = LoginViewModel()
    
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
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
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
        
        view.addSubview(backToRegisterButton)
        backToRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}
