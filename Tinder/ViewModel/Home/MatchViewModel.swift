import Firebase

final class MatchViewModel {
    
    func fetchCardUser(cardUID: String, completion: @escaping (User?) -> ()) {
        let reference = Firestore.firestore().collection("users").document(cardUID)
        reference.getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let dictionary = snapshot?.data() else { return }
            completion(User(dictionary: dictionary))
        }
    }
}
