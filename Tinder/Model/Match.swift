import Foundation

struct Match {
    
    // MARK: Properties
    let uid: String?
    let username: String?
    let profileImageUrl: String?
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.uid = dictionary["uid"] as? String
        self.username = dictionary["username"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}
