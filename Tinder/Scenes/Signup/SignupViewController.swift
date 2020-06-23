import UIKit
import Firebase

class SignupViewController: UIViewController {
    
    // MARK: Properties
    let profilePhotoButton = TDButton(backgroundColor: .white, title: "Select Photo", radius: 16, fontSize: 32)
    let fullNameTextField = TDTextField(padding: 16, placeholderText: "Enter full name", radius: 25)
    let emailTextField = TDTextField(padding: 16, placeholderText: "Enter email", radius: 25)
    let passwordTextField = TDTextField(padding: 16, placeholderText: "Enter password", radius: 25)
    let signupButton = TDButton(backgroundColor: UIColor.appColor(color: .darkPink), title: "Sign Up", titleColor: .white, radius: 25, fontSize: 24)
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField, signupButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    lazy var overrallStackView = UIStackView(arrangedSubviews: [profilePhotoButton, verticalStackView])
    let signupViewModel = SignUpViewModel()

    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        setupNotifications()
        handleTapGesture()
        setupRegistrationViewModelObserver()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.verticalSizeClass == .compact {
            handleLandscapeOrientation()
        } else {
            handlePortraitOrientation()
        }
    }
}


// MARK: - Methods
extension SignupViewController {
    
    @objc fileprivate func handleSignUp() {
        handleTapDismiss()
        signupViewModel.performSignUp { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlert(title: "Authentication Failed", message: error.localizedDescription, buttonTitle: "Ok")
                return
            }
            print("Authentication successfull")
        }
    }
    
    
    fileprivate func setupRegistrationViewModelObserver() {
        
        signupViewModel.bindalbeIsFormValid.bind { [weak self] isFormValid in
            guard let self = self, let isFormValid = isFormValid else { return }
            if isFormValid {
                self.signupButton.backgroundColor = UIColor.appColor(color: .darkPink)
                self.signupButton.setTitleColor(.white, for: .normal)
            } else {
                self.signupButton.backgroundColor = .lightGray
                self.signupButton.setTitleColor(.gray, for: .disabled)
            }
            self.signupButton.isEnabled = isFormValid
        }
        
        signupViewModel.bindableImage.bind { [weak self] image in
            guard let self = self else { return }
            self.profilePhotoButton.setImage(image, for: .normal)
        }
        
        signupViewModel.bindableIsRegistering.bind { [weak self] isRegistering in
            guard let self = self, let isRegistering = isRegistering else { return }
            if isRegistering {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        signupViewModel.fullName = fullNameTextField.text
        signupViewModel.email = emailTextField.text
        signupViewModel.password = passwordTextField.text
    }
    
    
    fileprivate func handleLandscapeOrientation() {
        overrallStackView.axis = .horizontal
        profilePhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
    }
    
    
    fileprivate func handlePortraitOrientation() {
        overrallStackView.axis = .vertical
        profilePhotoButton.heightAnchor.constraint(equalToConstant: 275).isActive = true
    }
    
    
    fileprivate func handleTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc fileprivate func handleTapDismiss() {
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
        let bottomSpace = view.frame.height - overrallStackView.frame.origin.y - overrallStackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -(difference + 10))
    }
    
    
    fileprivate func layoutUI() {
        profilePhotoButton.heightAnchor.constraint(equalToConstant: 275).isActive = true
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        
        profilePhotoButton.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        fullNameTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        signupButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signupButton.backgroundColor = .lightGray
        signupButton.setTitleColor(.gray, for: .disabled)
        signupButton.isEnabled = false
        
        overrallStackView.axis = .vertical
        overrallStackView.spacing = 16
        view.addSubview(overrallStackView)
        overrallStackView.centerInSuperview()
        overrallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
    }
    
    
    @objc fileprivate func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    
    fileprivate func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.appColor(color: .orange).cgColor, UIColor.appColor(color: .pink).cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}


// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension SignupViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: ImagePicker.EditedImage.key)] as? UIImage {
            signupViewModel.bindableImage.value = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: ImagePicker.OriginalImage.key)] as? UIImage {
            signupViewModel.bindableImage.value = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}
