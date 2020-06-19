import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    let imageUrl: String
    let attributedText: NSAttributedString
    let textAlignment: NSTextAlignment
}
