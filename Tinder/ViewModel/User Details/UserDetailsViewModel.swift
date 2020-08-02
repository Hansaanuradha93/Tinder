import Foundation

class UserDetailsViewModel {
    
    // MARK: Properties
    let uid: String
    let imageUrls: [String]
    let attributedText: NSAttributedString
    let currentUser: User?
        
    
    // MARK: Initializers
    init(uid: String = "", imageUrls: [String] = [""], attributedText: NSAttributedString = NSAttributedString(), currentUser: User? = nil) {
        self.uid = uid
        self.imageUrls = imageUrls
        self.attributedText = attributedText
        self.currentUser = currentUser
    }
}
