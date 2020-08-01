import UIKit

enum AssertColor: String {
    case lightGray = "Light_Gray"
    case regularGray = "Regular_Gray"
    case mediumGray = "Medium_Gray"
    case darkGray = "Dark_Gray"
    case orange = "Orange"
    case pink = "Pink"
    case darkPink = "Dark_Pink"
    case tealBlue = "Teal_Blue"
    case lightGreen = "Light_Green"
}


extension UIColor {
    static func appColor(color: AssertColor) -> UIColor {
        return UIColor(named: color.rawValue)!
    }
}
