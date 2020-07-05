import UIKit

class SwipingPhotosViewController: UIPageViewController {

    // MARK: Properties
    let controllers = [
        PhotoViewController(image: #imageLiteral(resourceName: "super_like_circle")),
        PhotoViewController(image: #imageLiteral(resourceName: "boost_circle")),
        PhotoViewController(image: #imageLiteral(resourceName: "like_circle")),
        PhotoViewController(image: #imageLiteral(resourceName: "super_like_circle")),
        PhotoViewController(image: #imageLiteral(resourceName: "refresh_circle"))
    ]
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = .white
        setViewControllers([controllers.first!], direction: .forward, animated: false)
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
