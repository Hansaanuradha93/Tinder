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
            
            guard let image = self.bindableImage.value,
                let uploadData = image.jpegData(compressionQuality: 0.75) else { return }
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            let filename = UUID().uuidString
            let storageRef = Storage.storage().reference().child("images/\(filename)")
            
            storageRef.putData(uploadData, metadata: metaData) { (_, error) in
                
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
                            guard let downloadUrl = url?.absoluteString else { return }
                            //TODO: Store the download url in Firestore
                            self.bindableIsRegistering.value = false
                            completion(nil)
                        }
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
