import Foundation

protocol ProducesChatLogViewModel {
    func toChatLogViewModel() -> ChatLogViewModel
}


class ChatLogViewModel {
    let uid: String
    let username: String
    let profileImageUrl: String
    
    
    init(uid: String, username: String, profileImageUrl: String) {
        self.uid = uid
        self.username = username
        self.profileImageUrl = profileImageUrl
    }
}
