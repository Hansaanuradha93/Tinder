import UIKit

struct User {
    
    // MARK: Properties
    let uid: String?
    let name: String?
    let age: Int?
    let profession: String?
    let imageUrls: [String]?
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.uid = dictionary["uid"] as? String
        self.name = dictionary["fullName"] as? String
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        let imageUrl = dictionary["imageUrl1"] as? String
        self.imageUrls = [imageUrl ?? ""]
    }
}


// MARK: - ProducesCardViewModel
extension User: ProducesCardViewModel {
    
    func toCardViewModel() -> CardViewModel {
        let nameString = name != nil ? name! : "Not available"
        let ageString = age != nil ? "\(age!)" : "N\\A"
        let professionString = profession != nil ? profession! : "Not available"
        let attributedText = NSMutableAttributedString(string: nameString, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        return CardViewModel(imageUrls: imageUrls ?? [String](), attributedText: attributedText, textAlignment: .left)
    }
}
