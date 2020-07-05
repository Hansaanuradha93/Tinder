import UIKit

class SwipingPhotosViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self

        view.backgroundColor = .white
        
        let redViewController = UIViewController()
        redViewController.view.backgroundColor = .red
        
        let controller = [redViewController]
        
        setViewControllers(controller, direction: .forward, animated: false)
    }
}


// MARK: -
extension SwipingPhotosViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let greenViewController = UIViewController()
        greenViewController.view.backgroundColor = .green
        return greenViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let yellowViewController = UIViewController()
        yellowViewController.view.backgroundColor = .yellow
        return yellowViewController
    }
    
    
}
