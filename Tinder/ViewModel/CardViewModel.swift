import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}


class CardViewModel {
    
    // MARK: Properties
    let imageUrls: [String]
    let attributedText: NSAttributedString
    let textAlignment: NSTextAlignment
    var imageIndexObserver: ((UIImage?) -> ())?
    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = imageUrls[imageIndex]
            let image = UIImage(named: imageUrl)
            imageIndexObserver?(image)
        }
    }
    
    
    // MARK: Initializers
    init(imageUrls: [String], attributedText: NSAttributedString, textAlignment: NSTextAlignment) {
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
    
    
    func goToPreviousPhot() {
        imageIndex = max( 0, imageIndex - 1)
    }
}
