import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}


struct CardViewModel {
    let imageUrls: [String]
    let attributedText: NSAttributedString
    let textAlignment: NSTextAlignment
}
