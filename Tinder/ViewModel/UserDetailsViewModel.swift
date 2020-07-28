import Firebase

class UserDetailsViewModel {
    
    // MARK: Properties
    let uid: String
    let imageUrls: [String]
    let attributedText: NSAttributedString
    let currentUser: User?
        
    
    // MARK: Initializers
    init(uid: String = "", imageUrls: [String] = [""], attributedText: NSAttributedString = NSAttributedString(), currentUser: User? = nil) {
        self.uid = uid
        self.imageUrls = imageUrls
        self.attributedText = attributedText
        self.currentUser = currentUser
    }
    
    
    func saveSwipe(isLiked: Bool, completion: @escaping (Bool, String) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Firestore.firestore().collection("swipes").document(uid)
        
        let cardUID = self.uid
        if isLiked { self.checkIfMatchExist(cardUID: cardUID, completion: completion) }

        let value = isLiked ? 1 : 0
        let documentData = [cardUID: value]
        
        reference.getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if snapshot?.exists ?? false {
                reference.updateData(documentData) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("Swipe successfully updated")
                }
            } else {
                reference.setData(documentData) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("Swipe successfully saved")
                }
            }
        }
    }
    
    
    fileprivate func checkIfMatchExist(cardUID: String, completion: @escaping (Bool, String) -> ()) {
        let reference = Firestore.firestore().collection("swipes").document(cardUID)
        reference.getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false, "")
                return
            }
            guard let data = snapshot?.data(), let uid = Auth.auth().currentUser?.uid else {
                completion(false, "")
                return
            }
            
            let hasMatched = data[uid] as? Int == 1
            completion(hasMatched, cardUID)
        }
    }
    
    
    func saveMatchToFirestore() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let cardUserData: [String: Any] = [
            "username": getUsernameFromAttributtedString(),
            "profileImageUrl": imageUrls.first ?? "",
            "uid": uid,
            "timestamp": Timestamp(date: Date())
        ]
        let ref = Firestore.firestore().collection("matches_messages")
        let currentUserRef = ref.document(currentUserID).collection("matches").document(uid)
        currentUserRef.setData(cardUserData) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
        
        guard let currentUser = currentUser  else { return }
        let currentUserData: [String: Any] = [
            "username": currentUser.name ?? "",
            "profileImageUrl": currentUser.imageUrl1 ?? "",
            "uid": currentUser.uid ?? "",
            "timestamp": Timestamp(date: Date())
        ]
        let cardUserRef = ref.document(uid).collection("matches").document(currentUserID)
        cardUserRef.setData(currentUserData) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    
    fileprivate func getUsernameFromAttributtedString() -> String {
        let delimiter = " "
        let token = attributedText.string.components(separatedBy: delimiter)
        let username = token[0] + " " + token[1]
        return username
    }
}
