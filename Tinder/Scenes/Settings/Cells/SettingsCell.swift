import UIKit

class SettingsCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseIdentifier = "SettingsCell"

    let textField = SettingsTextField()
        
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: Methods
extension SettingsCell {
    
    func setup(placehoder: String, text: String) {
        textField.placeholder = placehoder
        textField.text = text
    }
    
    
    private func layoutUI() {
        addSubview(textField)
        textField.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
}
