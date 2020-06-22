import UIKit
import Firebase

class SignUpViewModel {
    
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    // MARK: Bindlable
    var bindableImage = Bindalbe<UIImage>()
    var bindalbeIsFormValid = Bindalbe<Bool>()
    var bindableIsRegistering = Bindalbe<Bool>()
    
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
    
    
    fileprivate func saveImageToFirebase(completion: @escaping ((Error?) -> ())) {
        guard let image = self.bindableImage.value,
        let uploadData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = UUID().uuidString
        let storageRef = Storage.storage().reference().child("images/\(filename)")
        
        storageRef.putData(uploadData, metadata: nil) { (_, error) in
            
            if let error = error {
                self.bindableIsRegistering.value = false
                completion(error)
                return
            } else {
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        self.bindableIsRegistering.value = false
                        completion(error)
                        return
                    } else {
                        //TODO: Store the download url in Firestore
                        guard let downloadUrl = url?.absoluteString else { return }
                        self.bindableIsRegistering.value = false
                        completion(nil)
                    }
                }
            }
        }
    }
    
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindalbeIsFormValid.value = isFormValid
    }
}
