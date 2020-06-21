import UIKit

class RegistrationViewModel {
    
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    // MARK: Reactive Programming
    var isFormValidObserver: ((Bool) -> ())?
}


// MARK: - Methods
extension RegistrationViewModel {
    
    fileprivate func checkFormValidity() {
        
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
}
