import UIKit

class PhotoViewController: UIViewController {

    // MARK: Properties
    let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly2"))

    
    // MARK: Initializers
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.fillSuperview()
    }
}
