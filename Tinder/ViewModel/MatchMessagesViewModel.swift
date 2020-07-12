import Foundation
import Firebase

class MatchMessagesViewModel {
    
    func fetchMatches() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let reference = Firestore.firestore().collection("matches_messages").document(currentUserID).collection("matches")
        reference.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("here are my matches document")
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                print(documentSnapshot.data())
            })
        }
    }
}
