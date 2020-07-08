import UIKit
import Firebase

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}


class CardViewModel {
    
    // MARK: Properties
    let uid: String
    let imageUrls: [String]
    let attributedText: NSAttributedString
    let textAlignment: NSTextAlignment
    
    fileprivate var lastFetchedUser: User?
    fileprivate var currentUser: User?
    fileprivate let userPaginationLimit = 2
    
    // MARK: Bindable
    var bindableIsFetchingUsers = Bindable<Bool>()
    
    
    // MARK: Initializers
    init(uid: String = "", imageUrls: [String] = [""], attributedText: NSAttributedString = NSAttributedString(), textAlignment: NSTextAlignment = .center) {
        self.uid = uid
        self.imageUrls = imageUrls
        self.attributedText = attributedText
        self.textAlignment = textAlignment
    }
}


// MARK: - Methods
extension CardViewModel {
    
    fileprivate func fetchUsersFromFirestore(completion: @escaping (User?) -> ()) {
        let minAge = currentUser?.minSeekingAge ?? Constants.defaultMinimumSeekingAge
        let maxAge = currentUser?.maxSeekingAge ?? Constants.defaultMaximumSeekingAge
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
//        let paginationRef = query.order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: userPaginationLimit)
        query.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            self.bindableIsFetchingUsers.value = false
            if let _ = error {
                completion(nil)
                return
            }
            
            snapshot!.documents.forEach { (documentSnapshot) in
                let user = User(dictionary: documentSnapshot.data())
                self.lastFetchedUser = user
                completion(user)
            }
        }
    }
    
    
    func fetchCurrentUser(completion: @escaping (User?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        self.bindableIsFetchingUsers.value = true
        let reference = Firestore.firestore().collection("users").document(uid)
        reference.getDocument { (document, error) in
            if let error = error {
                self.bindableIsFetchingUsers.value = false
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let dictionary = document?.data() else {
                self.bindableIsFetchingUsers.value = false
                completion(nil)
                return
            }
            self.currentUser = User(dictionary: dictionary)
            self.fetchUsersFromFirestore(completion: completion)
        }
    }
}
