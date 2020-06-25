import UIKit
import Firebase

class SettingsViewController: UITableViewController {
    
    // MARK: Properties
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
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
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        fetchCurrentUser()
    }
}


// MARK: - Table View Header
extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerName = HeaderLabel()
        switch section {
        case 0:
            return header
        case 1:
            headerName.text = "Name"
        case 2:
            headerName.text = "Profession"
        case 3:
            headerName.text = "Age"
        default:
            headerName.text = "Bio"
        }
        return headerName
    }

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
}


// MARK: - Table View Data Source
extension SettingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath) as! SettingsCell
        switch indexPath.section {
        case 1:
            cell.setup(placehoder: "Name")
        case 2:
            cell.setup(placehoder: "Proofession")
        case 3:
            cell.setup(placehoder: "Age")
        default:
            cell.setup(placehoder: "Bio")
        }
        return cell
    }
}


// MARK: - Methods
extension SettingsViewController {
    
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Firestore.firestore().collection("users").document(uid)
        
        reference.getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let userInfoDictionary = document?.data() else { return }
            let user = User(dictionary: userInfoDictionary)
            print(user)
        }
    }
    
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tableView.addGestureRecognizer(tapGesture)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdentifier)
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
        print("Save")
    }
    
    
    @objc fileprivate func handleLogout() {
        print("Logout")
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
    }
}