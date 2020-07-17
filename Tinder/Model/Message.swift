import Firebase

struct Message {
    
    // MARK: Properties
    let text, fromID, toID: String?
    let timeStamp: Timestamp?
    let isFromCurrentUser: Bool?
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.text = dictionary["text"] as? String
        self.fromID = dictionary["fromID"] as? String
        self.toID = dictionary["toID"] as? String
        self.timeStamp = dictionary["timestamp"] as? Timestamp
        self.isFromCurrentUser = Auth.auth().currentUser?.uid == self.fromID
    }
}
