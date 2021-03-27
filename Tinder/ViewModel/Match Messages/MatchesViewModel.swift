import Firebase

class MatchesViewModel {
    
    // MARK: Properties
    private var matches = [Match]()
}


// MARK: - Methods
extension MatchesViewModel {
    
    func getMatchesCount() -> Int {
        return matches.count
    }
    
    
    func getMatchAt(_ indexPath: IndexPath) -> Match {
        return matches[indexPath.item]
    }
    
    
    func fetchMatches(completion: @escaping (Bool) -> ()) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let reference = Firestore.firestore().collection("matches_messages").document(currentUserID).collection("matches")
        reference.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                let match = Match(dictionary: dictionary)
                self.matches.append(match)
            })
            completion(true)
        }
    }
}
