import Firebase

class SettingsViewModel {
    
    // MARK: Properties
    
    // MARK: Bindable
    var bindableIsFetchingData = Bindable<Bool>()
    
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
}
