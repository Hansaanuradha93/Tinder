import UIKit

protocol SwipingPhotosViewControllerDelegate {
    func didTapCardViewBottom()
}


class SwipingPhotosViewController: UIPageViewController {

    // MARK: Properties
    fileprivate let barStackView = UIStackView(arrangedSubviews: [])
    fileprivate var controllers = [UIViewController]()
    fileprivate let barDiselectedColor = UIColor.appColor(color: .darkGray)
    fileprivate var isCardViewMode: Bool = false
    var swipingDelegate: SwipingPhotosViewControllerDelegate?
    
    var imageUrls: [String]! {
        didSet {
            controllers = imageUrls.map({ imageUrl -> UIViewController in
                let photoController = PhotoViewController(imageUrl: imageUrl)
                return photoController
            })
            setViewControllers([controllers.first!], direction: .forward, animated: false)
            setupBarViews()
        }
    }
    
    
    // MARK: Initializers
    init(isCardViewMode: Bool = false) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.isCardViewMode = isCardViewMode
    }

    
    required init?(coder: NSCoder) { fatalError() }

    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}


// MARK: - Methods
extension SwipingPhotosViewController {
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        guard let currentController = viewControllers?.first, let index = controllers.firstIndex(of: currentController) else { return }
        var nextIndex: Int = 0
        
        let tapLocation = gesture.location(in: nil)
        if tapLocation.y < 3.5 * view.frame.height / 4 {
            let shouldAdvanceNextPhoto = tapLocation.x > view.frame.width / 2 ? true : false
            if shouldAdvanceNextPhoto {
                nextIndex = min(index + 1, controllers.count - 1)
            } else {
                nextIndex = max(0, index - 1)
            }
            
            if nextIndex == 0 || nextIndex == controllers.count - 1 {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.prepare()
                generator.impactOccurred()
            } else {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.prepare()
                generator.impactOccurred()
            }
            
            
        } else {
            swipingDelegate?.didTapCardViewBottom()
        }
        
        let nextController = controllers[nextIndex]
        setViewControllers([nextController], direction: .forward, animated: false)
        barStackView.arrangedSubviews.forEach { $0.backgroundColor = barDiselectedColor }
        barStackView.arrangedSubviews[nextIndex].backgroundColor = .white
    }
    
    
    fileprivate func setupBarViews() {
        imageUrls.forEach { _ in
            let barView = UIView()
            barView.backgroundColor = barDiselectedColor
            barView.layer.cornerRadius = 2
            barStackView.addArrangedSubview(barView)
        }
        barStackView.distribution = .fillEqually
        barStackView.spacing = 5
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        view.addSubview(barStackView)
        let topPadding: CGFloat = isCardViewMode ? 16 : 60
        barStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: topPadding, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 4))
    }
    
    
    fileprivate func disableSwipingAbility() {
        for view in view.subviews {
            if let view = view as? UIScrollView {
                view.isScrollEnabled = false
            }
        }
    }
    
    
    fileprivate func setupViewController() {
        view.backgroundColor = .white
        dataSource = self
        delegate = self
        if isCardViewMode {
            disableSwipingAbility()
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        }
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
