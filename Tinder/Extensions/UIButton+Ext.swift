import UIKit

extension UIButton {
    
    func downloadImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.setImage(image, for: .normal) }
        }
    }
}
