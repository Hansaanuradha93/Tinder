import UIKit

class SwipingPhotosViewController: UIPageViewController {

    // MARK: Properties
    fileprivate let barStackView = UIStackView(arrangedSubviews: [])
    fileprivate var controllers = [UIViewController]()
    fileprivate let barDiselectedColor = UIColor.appColor(color: .darkGray)
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
            barView.backgroundColor = barDiselectedColor
            barView.layer.cornerRadius = 2
            barStackView.addArrangedSubview(barView)
        }
        barStackView.distribution = .fillEqually
        barStackView.spacing = 5
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        view.addSubview(barStackView)
        barStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 60, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 4))
    }
    
    
    fileprivate func setupViewController() {
        view.backgroundColor = .white
        dataSource = self
        delegate = self
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


// MARK: - UIPageViewControllerDelegate
extension SwipingPhotosViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentPhotoController = viewControllers?.first, let index = controllers.firstIndex(of: currentPhotoController) else { return }
        barStackView.arrangedSubviews.forEach { $0.backgroundColor = barDiselectedColor }
        barStackView.arrangedSubviews[index].backgroundColor = .white
    }
}
