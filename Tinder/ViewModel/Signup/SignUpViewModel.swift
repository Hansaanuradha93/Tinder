import UIKit
import Firebase

class SignUpViewModel {
    
    // MARK: Properties
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    // MARK: Bindlable
    var bindableImage = Bindable<UIImage>()
    var bindalbeIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
}


// MARK: - Methods
extension SignUpViewModel {
    
    func performSignUp(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        self.bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.bindableIsRegistering.value = false
                completion(error)
                return
            }
            self.saveImageToFirebase(completion: completion)
        }
    }
    
    
    private func saveImageToFirebase(completion: @escaping ((Error?) -> ())) {
        guard let image = self.bindableImage.value,
        let uploadData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = UUID().uuidString
        let storageRef = Storage.storage().reference().child("images/\(filename)")
        
        storageRef.putData(uploadData, metadata: nil) { (_, error) in
            if let error = error {
                self.bindableIsRegistering.value = false
                completion(error)
                return
            }
            self.fetchImageDownloadUrl(reference: storageRef, completion: completion)
        }
    }
    
    
    private func fetchImageDownloadUrl(reference: StorageReference, completion: @escaping (Error?) -> ()) {
        reference.downloadURL { (url, error) in
            if let error = error {
                self.bindableIsRegistering.value = false
                completion(error)
                return
            }
            let downloadUrl = url?.absoluteString ?? ""
            self.saveInfoToFirestore(imageUrl: downloadUrl, completion: completion)
        }
    }
    
    
    private func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let userInfo = [
            "uid": uid,
            "fullname": fullName ?? "",
            "email": email ?? "",
            "age": Constants.defaultUserAge,
            "imageUrl1": imageUrl,
            "minSeekingAge": Constants.defaultMinimumSeekingAge,
            "maxSeekingAge": Constants.defaultMaximumSeekingAge
            ] as [String : Any]
        Firestore.firestore().collection("users").document(uid).setData(userInfo) { [weak self] error in
            guard let self = self else { return }
            self.bindableIsRegistering.value = false
            if let error = error {
                completion(error)
                return
            }
            print("Authentication successfull")
            completion(nil)
        }
    }
    
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        bindalbeIsFormValid.value = isFormValid
    }
}
