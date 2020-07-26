import Foundation

class UserDetailsViewModel {
    
    // MARK: Properties
    let uid: String
    let imageUrls: [String]
    let attributedText: NSAttributedString
        
    
    // MARK: Initializers
    init(uid: String = "", imageUrls: [String] = [""], attributedText: NSAttributedString = NSAttributedString()) {
        self.uid = uid
        self.imageUrls = imageUrls
        self.attributedText = attributedText
    }
}
