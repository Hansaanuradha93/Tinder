import UIKit

class AgeRangeCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseIdentifier = "AgeRangeCell"
    
    var minSlider: UISlider = { // TODO: Refactor the UISlider
        let slider = UISlider()
        slider.minimumValue = Float(Constants.defaultMinimumSeekingAge)
        slider.maximumValue = Float(Constants.defaultMaximumSeekingAge)
        return slider
    }()
    
    var maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = Float(Constants.defaultMinimumSeekingAge)
        slider.maximumValue = Float(Constants.defaultMaximumSeekingAge)
        return slider
    }()
    
    fileprivate var minLabel: UILabel = {
        let label = UILabel()
        label.text = "Min .."
        return label
    }()
    
    fileprivate var maxLabel: UILabel = {
        let label = UILabel()
        label.text = "Max .."
        return label
    }()
    
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
}


// MARK: - Methods
extension AgeRangeCell {
    
    func setup(minValue: Int?, maxValue: Int?) {
        if let minValue = minValue {
            minLabel.text = "Min \(minValue)"
            minSlider.value = Float(minValue)
        }
        if let maxValue = maxValue {
            maxLabel.text = "Max \(maxValue)"
            maxSlider.value = Float(maxValue)
        }
    }
    
    
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
