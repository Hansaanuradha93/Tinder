import UIKit

class PhotoViewController: UIViewController {

    // MARK: Properties
    private let imageView = UIImageView()
    private var imageUrl = ""

    
    // MARK: Initializers
    init(imageUrl: String) {
        super.init(nibName: nil, bundle: nil)
        self.imageUrl = imageUrl
    }
    
    
    required init?(coder: NSCoder) { fatalError() }

    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}


// MARK: - Methods
private extension PhotoViewController {
    
    func setupLayout() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.downloadImage(from: imageUrl)
    }
}
