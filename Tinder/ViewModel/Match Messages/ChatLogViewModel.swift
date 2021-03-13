import Firebase

protocol ProducesChatLogViewModel {
    func toChatLogViewModel() -> ChatLogViewModel
}


class ChatLogViewModel {
    
    // MARK: Properties
    let uid: String
    let username: String
    let profileImageUrl: String
    var currentUser: User?
    
    private var messages = [Message]()
    
    
    // MARK: Initializers
    init( uid: String, username: String, profileImageUrl: String) {
        self.uid = uid
        self.username = username
        self.profileImageUrl = profileImageUrl
    }
}


// MARK: - Methods
extension ChatLogViewModel {
    
    func getMessagesCount() -> Int {
        return messages.count
    }
    
    
    func getMessageAt(_ indexPath: IndexPath) -> Message {
        return messages[indexPath.item]
    }
    
    
    func fetchMessages(completion: @escaping (Bool) -> ()) -> ListenerRegistration? {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(false)
            return nil
        }
        let matchID = uid
        let query = Firestore.firestore().collection("matches_messages").document(currentUserID).collection(matchID).order(by: "timestamp")
        
        let listener = query.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let documentChanges = querySnapshot?.documentChanges else { return }
            for change in documentChanges {
                if change.type == .added {
                    self.messages.append(Message(dictionary: change.document.data()))
                }
            }
            completion(true)
        }
        return listener
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
    
    
    func saveRecentMessages(message: String?, completion: @escaping (Bool) -> ()) {
        if let message = message, !message.isEmpty, let currentUser = currentUser {
            guard let currentUserID = Auth.auth().currentUser?.uid else {
                completion(false)
                return
            }
            let rootRef = Firestore.firestore().collection("matches_messages")
            let matchID = uid
            
            let data: [String : Any] = [
                "uid": matchID,
                "name": username,
                "profileImageUrl": profileImageUrl,
                "text": message,
                "timestamp": Timestamp(date: Date())
            ]
            
            let currentUserRef = rootRef.document(currentUserID).collection("recent_messages").document(matchID)
            currentUserRef.setData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                completion(true)
                print("Recent message saved successfully in current user side")
            }
            
            let messageData: [String : Any] = [
                "uid": currentUserID,
                "name": currentUser.name ?? "",
                "profileImageUrl": currentUser.imageUrl1 ?? "",
                "text": message,
                "timestamp": Timestamp(date: Date())
            ]
            
            let matchedUserRef = rootRef.document(matchID).collection("recent_messages").document(currentUserID)
            matchedUserRef.setData(messageData) { error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                completion(true)
                print("Recent message saved successfully in matched user side")
            }
        } else {
            completion(false)
        }
    }
}
