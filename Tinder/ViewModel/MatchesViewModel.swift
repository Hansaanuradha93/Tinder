import Firebase

class MatchesViewModel {
    func fetchMatches(completion: @escaping (Match?) -> ()) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let reference = Firestore.firestore().collection("matches_messages").document(currentUserID).collection("matches")
        reference.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                let match = Match(dictionary: dictionary)
                completion(match)
            })
        }
    }
}
