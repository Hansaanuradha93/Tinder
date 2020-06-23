import UIKit

struct User {
    
    // MARK: Properties
    let name: String
    let age: Int
    let profession: String
    let imageUrls: [String]
    
    // MARK: Initializers
    init(name: String, age: Int, profession: String, imageUrls: [String]) {
        self.name = name
        self.age = age
        self.profession = profession
        self.imageUrls = imageUrls
    }
    
    
    init(dictionary: [String : Any]) {
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.profession = dictionary["profession"] as? String ?? ""
        let imageUrl = dictionary["imageUrl1"] as? String ?? ""
        self.imageUrls = [imageUrl]
    }
}


// MARK: - ProducesCardViewModel
extension User: ProducesCardViewModel {
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        return CardViewModel(imageUrls: imageUrls, attributedText: attributedText, textAlignment: .left)
    }
}
