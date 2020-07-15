import UIKit

class ChatLogViewController: UICollectionViewController {

    // MARK: Properties
    fileprivate let navBarHeight: CGFloat = 120
    fileprivate lazy var customNavigationBar = ChatLogNavigationBar(match: match)
    fileprivate let statusBar = UIView()
    fileprivate var match: Match!
    fileprivate var messages = [Message(text: "Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1 Message 1", isFromCurrentUser: true),
                                Message(text: "Message 2", isFromCurrentUser: false),
                                Message(text: "Message 3", isFromCurrentUser: false),
                                Message(text: "Message 4", isFromCurrentUser: true)]
    
    lazy var redView: CustomInputAccessoryView = {
        let redView = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        redView.dropShadow(color: .lightGray, opacity: 0.1, offset: .init(width: 0, height: -8), radius: 8)
        redView.backgroundColor = .white
        redView.autoresizingMask = .flexibleHeight
        
        let textView = UITextView()
        textView.text = "It's working"
        textView.isScrollEnabled = false
        
        let dimensions: CGFloat = 60
        let sendButton = TDButton(title: "SEND", titleColor: .black, fontSize: 14)
        sendButton.setHeight(dimensions)
        sendButton.setWidth(dimensions)

        let stackView = UIStackView(arrangedSubviews: [textView, sendButton])
        stackView.alignment = .center
        redView.addSubview(stackView)
        stackView.fillSuperview()
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return redView
    }()
    
    
    // MARK: Initializers
    init(match: Match) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.match = match
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
    }
    
    
    override var inputAccessoryView: UIView? {
        get { return redView }
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}


// MARK: - Collection View Data Source
extension ChatLogViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseID, for: indexPath) as! MessageCell
        cell.set(message: messages[indexPath.item])
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ChatLogViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedCell = MessageCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedCell.set(message: messages[indexPath.item])
        estimatedCell.layoutIfNeeded()
        let estimatedSize = estimatedCell.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: 1000))
        return CGSize(width: view.frame.width, height: estimatedSize.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}


// MARK: - Methods
extension ChatLogViewController {
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
    fileprivate func setupLayout() {
        view.addSubview(customNavigationBar)
        customNavigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
        customNavigationBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        statusBar.backgroundColor = .white
        view.addSubview(statusBar)
        statusBar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = navBarHeight
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseID)
    }
}
