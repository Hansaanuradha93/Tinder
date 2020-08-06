import UIKit

struct Advertiser {
    let title, brandName, posterImageUrl: String?
}


// MARK: - ProducesCardViewModel
extension Advertiser: ProducesCardViewModel {
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: title ?? "", attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "\n\(String(describing: brandName))", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]))
        return CardViewModel(uid: "", imageUrls: [posterImageUrl ?? ""], attributedText: attributedText, textAlignment: .center)
    }
}
