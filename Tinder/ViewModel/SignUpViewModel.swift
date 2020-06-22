import UIKit

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
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindalbeIsFormValid.value = isFormValid
    }
}
