import UIKit

class SettingsCell: UITableViewCell {
    
    // MARK: Class
    class SettingsTextField: UITextField {
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 44)
        }
    }
    
    // MARK: Properties
    fileprivate var textField: SettingsTextField = {
        let textField = SettingsTextField()
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
    
    func setup(placehoder: String, text: String) {
        textField.placeholder = placehoder
        textField.text = text
    }
    
    
    fileprivate func layoutUI() {
        addSubview(textField)
        textField.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
}
