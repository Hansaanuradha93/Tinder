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
    fileprivate let userPaginationLimit = 2
    var currentUser: User?
    
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
    
    fileprivate func fetchUsersFromFirestore(uid: String, swipes: [String : Int]?, completion: @escaping (User?) -> ()) {
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
                let isNotCurrentUser = user.uid != uid
                // TODO: - uncomment below line to filtered already swiped users
//                let hasNotSwipedBefore = swipes?[user.uid ?? ""] == nil
                let hasNotSwipedBefore = true
                if isNotCurrentUser && hasNotSwipedBefore {
                    completion(user)
                } else {
                   completion(nil)
                }
            }
        }
    }
    
    
    fileprivate func fetchSwipes(uid: String, completion: @escaping (User?) -> ()) {
        let reference = Firestore.firestore().collection("swipes").document(uid)
        reference.getDocument { snapshot, error in
            if let error = error {
                self.bindableIsFetchingUsers.value = false
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let swipesData = snapshot?.data() as? [String : Int] else {
                self.bindableIsFetchingUsers.value = false
                self.fetchUsersFromFirestore(uid: uid, swipes: nil, completion: completion)
                return
            }
            self.fetchUsersFromFirestore(uid: uid, swipes: swipesData, completion: completion)
        }
    }
    
    
    func fetchCurrentUser(completion: @escaping (User?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        self.bindableIsFetchingUsers.value = true
        let reference = Firestore.firestore().collection("users").document(uid)
        reference.getDocument { document, error in
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
            self.fetchSwipes(uid: uid, completion: completion)
            NetworkManager.shared.cacheImage(from: self.currentUser?.imageUrl1 ?? "")
        }
    }
}
