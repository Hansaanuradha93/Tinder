import Firebase

class SettingsViewModel {
    
    // MARK: Properties
    
    // MARK: Bindable
    var bindableIsFetchingData = Bindable<Bool>()
    var bindableIsSavingUserData = Bindable<Bool>()

    
    func fetchCurrentUser(completion: @escaping (User?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        bindableIsFetchingData.value = true
        let reference = Firestore.firestore().collection("users").document(uid)
        reference.getDocument { (document, error) in
            self.bindableIsFetchingData.value = false
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let dictionary = document?.data() else { return }
            completion(User(dictionary: dictionary))
        }
    }
    
    
    func saveUserData(user: User?, completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        bindableIsSavingUserData.value = true
    
        let documentData: [String: Any] = [
            "uid": uid,
            "fullname": user?.name ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "bio": user?.bio ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "minSeekingAge": user?.minSeekingAge ?? Constants.defaultMinimumSeekingAge,
            "maxSeekingAge": user?.maxSeekingAge ?? Constants.defaultMaximumSeekingAge
        ]
        
        Firestore.firestore().collection("users").document(uid).updateData(documentData) { [weak self] error in
            guard let self = self else { return }
            self.bindableIsSavingUserData.value = false
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            print("user info updated successfully")
            completion(true)
        }
    }
}
