import UIKit

class PhotoViewController: UIViewController {

    // MARK: Properties
    fileprivate let imageView = UIImageView()
    fileprivate var imageUrl = ""

    
    // MARK: Initializers
    init(imageUrl: String) {
        super.init(nibName: nil, bundle: nil)
        self.imageUrl = imageUrl
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.downloadImage(from: imageUrl)
    }
}
