import Foundation

struct Match {
    
    // MARK: Properties
    let uid, username, profileImageUrl: String?
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.uid = dictionary["uid"] as? String
        self.username = dictionary["username"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}


// MARK: - ProducesChatLogViewModel
extension Match: ProducesChatLogViewModel {
    
    func toChatLogViewModel() -> ChatLogViewModel {
        return ChatLogViewModel(uid: uid ?? "", username: username ?? "", profileImageUrl: profileImageUrl ?? "")
    }
}
