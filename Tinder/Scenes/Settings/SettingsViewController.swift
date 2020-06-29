import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    // MARK: Properties
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    let tableView = UITableView()
    
    lazy var header: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        let padding: CGFloat = 16
        
        let verticalStackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 16
        
        let overrallStackView = UIStackView(arrangedSubviews: [image1Button, verticalStackView])
        overrallStackView.distribution = .fillEqually
        overrallStackView.spacing = 16
        view.addSubview(overrallStackView)
        overrallStackView.fillSuperview(padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return view
    }()
    
    var user: User?
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        fetchCurrentUser()
    }
}


// MARK: - Table View Header
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerName = HeaderLabel()
        headerName.font = UIFont.boldSystemFont(ofSize: 16)
        switch section {
        case 0:
            return header
        case 1:
            headerName.text = "Name"
        case 2:
            headerName.text = "Profession"
        case 3:
            headerName.text = "Age"
        case 4:
            headerName.text = "Bio"
        default:
            headerName.text = "Seeking Age Range"
        }
        return headerName
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 300
        default:
            return 40
        }
    }
}


// MARK: - Table View Data Source
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath) as! SettingsCell
        switch indexPath.section {
        case 1:
            settingsCell.setup(placehoder: "Name", text: user?.name ?? "")
            settingsCell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            settingsCell.setup(placehoder: "Proofession", text: user?.profession ?? "")
            settingsCell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            settingsCell.setup(placehoder: "Age", text: "\(user?.age ?? 0)")
            settingsCell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
        case 4:
            settingsCell.setup(placehoder: "Bio", text: "")
            settingsCell.textField.addTarget(self, action: #selector(handleBioChange), for: .editingChanged)
        default:
            let ageRangeCell = tableView.dequeueReusableCell(withIdentifier: AgeRangeCell.reuseIdentifier, for: indexPath) as! AgeRangeCell
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinSlider), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxSlider), for: .valueChanged)

            return ageRangeCell
        }
        return settingsCell
    }
}


// MARK: - Methods
extension SettingsViewController {
    
    @objc fileprivate func handleMinSlider(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        let minValue = Int(slider.value)
        ageCell.minLabel.text = "Min \(minValue)"
        self.user?.minSeekingAge = minValue
    }
    
    
    @objc fileprivate func handleMaxSlider(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        let maxValue = Int(slider.value)
        ageCell.maxLabel.text = "Max \(maxValue)"
        self.user?.maxSeekingAge = maxValue
    }
    
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        user?.name = textField.text 
    }
    
    
    @objc fileprivate func handleProfessionChange(textField: UITextField) {
        user?.profession = textField.text
    }
    
    
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        user?.age = Int(textField.text ?? "")
    }
    
    
    @objc fileprivate func handleBioChange(textField: UITextField) {
        // TODO: capture the user's bio
    }
    
    
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.showPreloader()
        let reference = Firestore.firestore().collection("users").document(uid)
        
        reference.getDocument { (document, error) in
            self.hidePreloader()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let dictionary = document?.data() else { return }
            self.user = User(dictionary: dictionary)
            self.updateUI()
        }
    }
    
    
    fileprivate func updateUI() {
        DispatchQueue.main.async { self.tableView.reloadData() }
        if let imageUrl1 = user?.imageUrl1 {
            image1Button.downloadImage(from: imageUrl1)
        }
        if let imageUrl2 = user?.imageUrl2 {
            image2Button.downloadImage(from: imageUrl2)
        }
        if let imageUrl3 = user?.imageUrl3 {
            image3Button.downloadImage(from: imageUrl3)
        }
    }
    
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tableView.addGestureRecognizer(tapGesture)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdentifier)
        tableView.register(AgeRangeCell.self, forCellReuseIdentifier: AgeRangeCell.reuseIdentifier)
    }
    
    
    @objc fileprivate func handleTap() {
        view.endEditing(true)
    }
    
    
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
       let imagePickerController = TDImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.button = button
        present(imagePickerController, animated: true)
    }
    
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    
    @objc fileprivate func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.showPreloader()
    
        let documentData: [String: Any] = [
            "uid": uid,
            "fullname": user?.name ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "minSeekingAge": user?.minSeekingAge ?? 20,
            "maxSeekingAge": user?.maxSeekingAge ?? 80
        ]
        
        Firestore.firestore().collection("users").document(uid).setData(documentData) { [weak self] error in
            guard let self = self else { return }
            self.hidePreloader()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("user info updated successfully")
        }
    }
    
    
    @objc fileprivate func handleLogout() {
        // TODO: Logout
    }
    
    
    fileprivate func createButton(selector: Selector) -> UIButton {
        let button = TDButton(backgroundColor: .white, title: "Select Photo", radius: 16, fontSize: 20)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        ]
    }
}


// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension SettingsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let button = (picker as? TDImagePickerController)?.button
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: ImagePicker.EditedImage.key)] as? UIImage {
            button?.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: ImagePicker.OriginalImage.key)] as? UIImage {
            button?.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        dismiss(animated: true, completion: nil)
        
        guard let image = button?.image(for: .normal), let uploadData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = UUID().uuidString
        let reference = Storage.storage().reference().child("images/\(filename)")
        
        self.showPreloader()
        reference.putData(uploadData, metadata: nil) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                self.hidePreloader()
                return
            }
            
            reference.downloadURL { (url, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.hidePreloader()
                    return
                }
                
                guard let downloadUrl = url?.absoluteString else { return }
                self.hidePreloader()
                if button == self.image1Button {
                    self.user?.imageUrl1 = downloadUrl
                } else if button == self.image2Button {
                    self.user?.imageUrl2 = downloadUrl
                } else {
                    self.user?.imageUrl3 = downloadUrl
                }
                self.handleSave()
            }
        }
    }
}
