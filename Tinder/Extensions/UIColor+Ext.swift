import UIKit

enum AssertColor: String {
    case darkGray = "Dark_Gray"
}


extension UIColor {
    static func appColor(color: AssertColor) -> UIColor {
        return UIColor(named: color.rawValue)!
    }
}
