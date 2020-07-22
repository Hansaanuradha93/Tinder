import Firebase

struct RecentMessage {
    
    // MARK: Properties
    let text, uid, name, profileImageUrl: String?
    let timestamp: Timestamp?
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.text = dictionary["text"] as? String
        self.uid = dictionary["uid"] as? String
        self.name = dictionary["name"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.timestamp = dictionary["timestamp"] as? Timestamp
    }
}


// MARK: - ProducesChatLogViewModel
extension RecentMessage: ProducesChatLogViewModel {
    
    func toChatLogViewModel() -> ChatLogViewModel {
        return ChatLogViewModel(uid: uid ?? "", username: name ?? "", profileImageUrl: profileImageUrl ?? "")
    }
}
