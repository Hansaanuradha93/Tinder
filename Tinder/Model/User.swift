import UIKit

struct User {
    let name: String
    let age: Int
    let profession: String
    let imageUrl: String
}


// MARK: - ProducesCardViewModel
extension User: ProducesCardViewModel {
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        return CardViewModel(imageUrls: [imageUrl], attributedText: attributedText, textAlignment: .left)
    }
}
