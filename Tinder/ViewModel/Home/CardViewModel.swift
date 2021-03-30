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
    
    private var lastFetchedUser: User?
    private let userPaginationLimit = 2
    var currentUser: User?
    var users = [String: User]()
    
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
    
    private func fetchUsersFromFirestore(uid: String, swipes: [String : Int]?, completion: @escaping (User?) -> ()) {
        let minAge = currentUser?.minSeekingAge ?? Constants.defaultMinimumSeekingAge
        let maxAge = currentUser?.maxSeekingAge ?? Constants.defaultMaximumSeekingAge
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge).limit(to: Constants.defaultUsersCount)
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
                self.users[user.uid ?? ""] = user
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
    
    
    private func fetchSwipes(uid: String, completion: @escaping (User?) -> ()) {
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
    
    
    func saveSwipe(isLiked: Bool, cardView: CardView?, completion: @escaping (Bool, String) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Firestore.firestore().collection("swipes").document(uid)
        
        guard let cardUID = cardView?.cardViewModel.uid else { return }
        if isLiked { self.checkIfMatchExist(cardUID: cardUID, completion: completion) }

        let value = isLiked ? 1 : 0
        let documentData = [cardUID: value]
        
        reference.getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if snapshot?.exists ?? false {
                reference.updateData(documentData) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("Swipe successfully updated")
                }
            } else {
                reference.setData(documentData) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("Swipe successfully saved")
                }
            }
        }
    }
    
    
    private func checkIfMatchExist(cardUID: String, completion: @escaping (Bool, String) -> ()) {
        let reference = Firestore.firestore().collection("swipes").document(cardUID)
        reference.getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false, "")
                return
            }
            guard let data = snapshot?.data(), let uid = Auth.auth().currentUser?.uid else {
                completion(false, "")
                return
            }
            
            let hasMatched = data[uid] as? Int == 1
            completion(hasMatched, cardUID)
        }
    }
    
    
    func saveMatchToFirestore(cardUID: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid, let cardUser = users[cardUID] else { return }
        let cardUserData: [String: Any] = [
            "username": cardUser.name ?? "",
            "profileImageUrl": cardUser.imageUrl1 ?? "",
            "uid": cardUID,
            "timestamp": Timestamp(date: Date())
        ]
        let ref = Firestore.firestore().collection("matches_messages")
        let currentUserRef = ref.document(currentUserID).collection("matches").document(cardUID)
        currentUserRef.setData(cardUserData) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
        
        guard let currentUser = currentUser  else { return }
        let currentUserData: [String: Any] = [
            "username": currentUser.name ?? "",
            "profileImageUrl": currentUser.imageUrl1 ?? "",
            "uid": currentUser.uid ?? "",
            "timestamp": Timestamp(date: Date())
        ]
        let cardUserRef = ref.document(cardUID).collection("matches").document(currentUserID)
        cardUserRef.setData(currentUserData) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
}
