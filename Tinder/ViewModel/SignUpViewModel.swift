import UIKit

class SignUpViewModel {
    
    var image: UIImage? { didSet { imageObserver?(image) } }
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    // MARK: Reactive Programming
    var isFormValidObserver: ((Bool) -> ())?
    var imageObserver: ((UIImage?) -> ())?
}


// MARK: - Methods
extension SignUpViewModel {
    
    fileprivate func checkFormValidity() {
        
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
}
