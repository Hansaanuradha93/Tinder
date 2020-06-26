import UIKit

struct User {
    
    // MARK: Properties
    var uid: String?
    var name: String?
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?

    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.uid = dictionary["uid"] as? String
        self.name = dictionary["fullname"] as? String
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
    }
}


// MARK: - ProducesCardViewModel
extension User: ProducesCardViewModel {
    
    func toCardViewModel() -> CardViewModel {
        let nameString = name != nil ? name! : "Not available"
        let ageString = age != nil ? "\(age!)" : "N\\A"
        let professionString = profession != nil ? profession! : "Not available"
        var imageUrls = [String]()
        let attributedText = NSMutableAttributedString(string: nameString, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        if let url = imageUrl1 { imageUrls.append(url) }
        if let imageUrl2 = imageUrl2 { imageUrls.append(imageUrl2) }
        if let imageUrl3 = imageUrl3 { imageUrls.append(imageUrl3) }
        return CardViewModel(imageUrls: imageUrls, attributedText: attributedText, textAlignment: .left)
    }
}
