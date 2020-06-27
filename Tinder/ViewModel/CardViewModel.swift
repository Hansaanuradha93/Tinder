import UIKit
import Firebase

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}


class CardViewModel {
    
    // MARK: Properties
    let imageUrls: [String]
    let attributedText: NSAttributedString
    let textAlignment: NSTextAlignment
    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = imageUrls[imageIndex]
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    var bindableIsFetchingUsers = Bindalbe<Bool>()
    fileprivate var lastFetchedUser: User?
    fileprivate let userPaginationLimit = 2

    
    // MARK: Reactive Programming
    var imageIndexObserver: ((Int, String?) -> ())?
    
    
    // MARK: Initializers
    init(imageUrls: [String] = [""], attributedText: NSAttributedString = NSAttributedString(), textAlignment: NSTextAlignment = .center) {
        self.imageUrls = imageUrls
        self.attributedText = attributedText
        self.textAlignment = textAlignment
    }
}


// MARK: - Methods
extension CardViewModel {
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
    
    
    func fetchUsersFromFirestore(completion: @escaping (User?) -> ()) {
        self.bindableIsFetchingUsers.value = true
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: userPaginationLimit)
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
}
