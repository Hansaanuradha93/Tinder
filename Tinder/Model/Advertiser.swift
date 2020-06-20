import UIKit

struct Advertiser {
    let title: String
    let brandName: String
    let posterImageUrl: String
}


// MARK: - ProducesCardViewModel
extension Advertiser: ProducesCardViewModel {
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "\n\(brandName)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]))
        return CardViewModel(imageUrls: [posterImageUrl], attributedText: attributedText, textAlignment: .center)
    }
}
