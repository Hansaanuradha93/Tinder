import Foundation
import Firebase

class MatchMessagesViewModel {
    fileprivate var recentMessagesDictionary = [String : RecentMessage]()
    fileprivate var recentMessages = [RecentMessage]()
}


// MARK: - Methods
extension MatchMessagesViewModel {
    
    func getRecentMessageCount() -> Int {
        return recentMessages.count
    }
    
    
    func getRecentMessageAt(_ indexPath: IndexPath) -> RecentMessage {
        return recentMessages[indexPath.item]
    }
    
    
    func fetchRecentMessages(completion: @escaping ([RecentMessage]?) -> ()) -> ListenerRegistration? {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return nil }
        let reference = Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages")
        let listener = reference.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let documentChanges = querySnapshot?.documentChanges else {
                completion(nil)
                return
            }
            for change in documentChanges {
                if change.type == .added || change.type == .modified {
                    let recentMessage = RecentMessage(dictionary: change.document.data())
                    self.recentMessagesDictionary[recentMessage.uid ?? ""] = recentMessage
                }
            }
            self.resetRecentMessages(completion: completion)
        }
        return listener
    }
    
    
    fileprivate func resetRecentMessages(completion: @escaping ([RecentMessage]?) -> ()) {
        let values = Array(recentMessagesDictionary.values)
        recentMessages = values.sorted(by: { (recentMessage1, recentMessage2) -> Bool in
            guard let timestamp1 = recentMessage1.timestamp, let timestamp2 = recentMessage2.timestamp else { return false }
            return timestamp1.compare(timestamp2) == .orderedDescending
        })
        completion(recentMessages)
    }
}
