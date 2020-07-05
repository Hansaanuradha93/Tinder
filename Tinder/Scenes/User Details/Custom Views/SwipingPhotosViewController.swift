import UIKit

class SwipingPhotosViewController: UIPageViewController {

    // MARK: Properties
    let barStackView = UIStackView(arrangedSubviews: [])
    var controllers = [UIViewController]()
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ imageUrl -> UIViewController in
                let photoController = PhotoViewController(imageUrl: imageUrl)
                return photoController
            })
            setViewControllers([controllers.first!], direction: .forward, animated: false)
            setupBarViews()
        }
    }
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}


// MARK: - Methods
extension SwipingPhotosViewController {
    
    fileprivate func setupBarViews() {
        cardViewModel.imageUrls.forEach { _ in
            let barView = UIView()
            barView.backgroundColor = .white
            barView.layer.cornerRadius = 2
            barStackView.addArrangedSubview(barView)
        }
        barStackView.distribution = .fillEqually
        barStackView.spacing = 5
        view.addSubview(barStackView)
        barStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 4))
    }
    
    
    fileprivate func setupViewController() {
        dataSource = self
        view.backgroundColor = .white
    }
}


// MARK: - UIPageViewControllerDataSource
extension SwipingPhotosViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
}
