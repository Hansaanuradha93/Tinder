import UIKit

enum AssertColor: String {
    case darkGray = "Dark_Gray"
    case orange = "Orange"
    case pink = "Pink"
    case darkPink = "Dark_Pink"
}


extension UIColor {
    static func appColor(color: AssertColor) -> UIColor {
        return UIColor(named: color.rawValue)!
    }
}
