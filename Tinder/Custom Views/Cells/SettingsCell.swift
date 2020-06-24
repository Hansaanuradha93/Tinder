import UIKit

class SettingsCell: UITableViewCell {
    
    // MARK: Properties
    fileprivate var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        return textField
    }()
    
    static let reuseIdentifier = "SettingsCell"
    
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: Methods
extension SettingsCell {
    
    func setup(placehoder: String) {
        textField.placeholder = placehoder
    }
    
    
    fileprivate func layoutUI() {
        addSubview(textField)
        textField.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
}
