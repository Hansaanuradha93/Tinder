import Foundation

struct Message {
    
    // MARK: Properties
    let text: String?
    
    
    // MARK: Initializers
    init(dictionary: [String : Any]) {
        self.text = dictionary["text"] as? String
    }
}
