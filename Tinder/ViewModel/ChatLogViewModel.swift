import Firebase

protocol ProducesChatLogViewModel {
    func toChatLogViewModel() -> ChatLogViewModel
}


class ChatLogViewModel {
    
    // MARK: Properties
    let uid: String
    let username: String
    let profileImageUrl: String
    
    
    // MARK: Initializers
    init(uid: String, username: String, profileImageUrl: String) {
        self.uid = uid
        self.username = username
        self.profileImageUrl = profileImageUrl
    }
    
    
    func saveMessages(message: String?, completion: @escaping (Bool) -> () ) {
        if let message = message, !message.isEmpty {
            guard let currentUserID = Auth.auth().currentUser?.uid else {
                completion(false)
                return
            }
            
            let rootRef = Firestore.firestore().collection("matches_messages")
            let matchID = uid
            let documentData: [String : Any] = [
                "text" : message,
                "fromID": currentUserID,
                "toID": matchID,
                "timestamp": Timestamp(date: Date())
            ]
            
            let currentUserRef = rootRef.document(currentUserID).collection(matchID)
            currentUserRef.addDocument(data: documentData) { error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                completion(true)
            }
            
            let matchUserRef = rootRef.document(matchID).collection(currentUserID)
            matchUserRef.addDocument(data: documentData) { error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                completion(true)
            }
        } else {
            completion(false)
        }
    }
}
