import UIKit

class SettingsViewController: UITableViewController {
    
    // MARK: Properties
    lazy var image1Button = createButton()
    lazy var image2Button = createButton()
    lazy var image3Button = createButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .red
        let paddding: CGFloat = 16
        
        let verticalStackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 16
        
        let overrallStackView = UIStackView(arrangedSubviews: [image1Button, verticalStackView])
        overrallStackView.distribution = .fillEqually
        overrallStackView.spacing = 16
        header.addSubview(overrallStackView)
        overrallStackView.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: paddding, left: paddding, bottom: paddding, right: paddding))
        
        return header
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
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
    
    
    fileprivate func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
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
