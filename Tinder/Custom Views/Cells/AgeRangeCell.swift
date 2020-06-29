import UIKit

class AgeRangeCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseIdentifier = "AgeRangeCell"
    
    var minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 80
        return slider
    }()
    
    var maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 80
        return slider
    }()
    
    var minLabel: UILabel = {
        let label = UILabel()
        label.text = "Min 20"
        return label
    }()
    
    var maxLabel: UILabel = {
        let label = UILabel()
        label.text = "Max 20"
        return label
    }()
    
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}


// MARK: - Methods
extension AgeRangeCell {
    
    fileprivate func layoutUI() {
        let minStackView = UIStackView(arrangedSubviews: [minLabel, minSlider])
        minStackView.spacing = 8
        
        let maxStackView = UIStackView(arrangedSubviews: [maxLabel, maxSlider])
        maxStackView.spacing = 8
        
        let padding: CGFloat = 16
        let overallSrachView = UIStackView(arrangedSubviews: [minStackView, maxStackView])
        overallSrachView.axis = .vertical
        overallSrachView.spacing = padding
        addSubview(overallSrachView)
        overallSrachView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
    }
}
