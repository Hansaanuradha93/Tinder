import Foundation

struct Message {
    
    // MARK: Properties
    let text: String?
    
    
    // MARK: Initializers
    init(text: String) {
        self.text = text
    }
    
    
    init(dictionary: [String : Any]) {
        self.text = dictionary["text"] as? String
    }
}
