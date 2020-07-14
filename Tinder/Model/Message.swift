import Foundation

struct Message {
    
    // MARK: Properties
    let text: String?
    let isFromCurrentUser: Bool?
    
    
    // MARK: Initializers
    init(text: String, isFromCurrentUser: Bool) {
        self.text = text
        self.isFromCurrentUser = isFromCurrentUser
    }
    
    
    init(dictionary: [String : Any]) {
        self.text = dictionary["text"] as? String
        self.isFromCurrentUser = dictionary["isFromCurrentUser"] as? Bool
    }
}
