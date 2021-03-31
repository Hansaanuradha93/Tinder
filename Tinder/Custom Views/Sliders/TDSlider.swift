import UIKit

class TDSlider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
   
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
}


// MARK: - Methods
extension TDSlider {
    
    private func setupUI() {
        minimumValue = Float(Constants.defaultMinimumSeekingAge)
        maximumValue = Float(Constants.defaultMaximumSeekingAge)
        isContinuous = true
        layer.cornerRadius = 30
        tintColor = UIColor.appColor(color: .pink)
        setThumbImage(Asserts.sliderThumb, for: .normal)
        setThumbImage(Asserts.sliderThumb, for: .highlighted)
    }
}

