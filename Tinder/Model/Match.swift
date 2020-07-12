import Foundation

struct Match {
    
    // MARK: Properties
    let username: String?
    let profileImageUrl: String?
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.username = dictionary["username"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}
