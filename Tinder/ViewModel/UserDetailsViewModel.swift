import Firebase

class UserDetailsViewModel {
    
    // MARK: Properties
    let uid: String
    let imageUrls: [String]
    let attributedText: NSAttributedString
        
    
    // MARK: Initializers
    init(uid: String = "", imageUrls: [String] = [""], attributedText: NSAttributedString = NSAttributedString()) {
        self.uid = uid
        self.imageUrls = imageUrls
        self.attributedText = attributedText
    }
    
    
    func saveSwipe(isLiked: Bool, completion: @escaping (Bool, String) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Firestore.firestore().collection("swipes").document(uid)
        
        let cardUID = self.uid
        if isLiked {
//            self.checkIfMatchExist(cardUID: uid, completion: completion)
        }

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
}
