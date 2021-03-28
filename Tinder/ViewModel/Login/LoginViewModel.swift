import Foundation
import Firebase

class LoginViewModel {
    
    // MARK: Properties
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    // MARK: Bindable
    var isLoggingIn = Bindable<Bool>()
    var isFormValid = Bindable<Bool>()
}


// MARK: - Methods
extension LoginViewModel {
    
    private func checkFormValidity() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }
    
    
    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        isLoggingIn.value = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] response, error in
            guard let self = self else { return }
            self.isLoggingIn.value = false
            if let error = error {
                completion(error)
                return
            }
            print("Logged in successfully")
            completion(nil)
        }
    }
}
