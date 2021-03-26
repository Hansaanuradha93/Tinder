import UIKit

class AgeRangeCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseIdentifier = "AgeRangeCell"
    
    let minSlider = TDSlider()
    let maxSlider = TDSlider()
    private let minLabel = TDLabel(text: Strings.minimumPlaceholder, textAlignment: .left)
    private let maxLabel = TDLabel(text: Strings.maximumPlaceholder, textAlignment: .left)
    
    
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
            minLabel.text = "\(Strings.min) \(minValue)"
            minSlider.value = Float(minValue)
        }
        if let maxValue = maxValue {
            maxLabel.text = "\(Strings.max) \(maxValue)"
            maxSlider.value = Float(maxValue)
        }
    }
    
    
    private func layoutUI() {
        let edgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        let spacing: CGFloat = 10
        
        let minStackView = UIStackView(arrangedSubviews: [minLabel, minSlider])
        minStackView.spacing = spacing
        minStackView.alignment = .center
        minStackView.isLayoutMarginsRelativeArrangement = true
        minStackView.layoutMargins = edgeInsets
        
        let maxStackView = UIStackView(arrangedSubviews: [maxLabel, maxSlider])
        maxStackView.spacing = spacing
        maxStackView.alignment = .center
        maxStackView.isLayoutMarginsRelativeArrangement = true
        maxStackView.layoutMargins = edgeInsets
        
        let padding: CGFloat = 16
        let overallSrachView = UIStackView(arrangedSubviews: [minStackView, maxStackView])
        overallSrachView.axis = .vertical
        overallSrachView.spacing = padding
        addSubview(overallSrachView)
        overallSrachView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
    }
}
