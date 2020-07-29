import UIKit
import Firebase

class ChatLogViewController: UICollectionViewController {

    // MARK: Properties
    fileprivate var viewModel: ChatLogViewModel!
    fileprivate let navBarHeight: CGFloat = 120
    fileprivate lazy var customNavigationBar = ChatLogNavigationBar(chatLogViewModel: viewModel)
    fileprivate let statusBar = UIView()
    fileprivate lazy var messageInputView = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
    fileprivate var listener: ListenerRegistration?
    
    
    // MARK: Initializers
    init(chatLogViewModel: ChatLogViewModel) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.viewModel = chatLogViewModel
    }
    
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
        fetchMessages()
        setupNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        if isMovingFromParent { listener?.remove() }
    }
    
    
    override var inputAccessoryView: UIView? {
        get { return messageInputView }
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}


// MARK: - Collection View Data Source
extension ChatLogViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getMessagesCount()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseID, for: indexPath) as! MessageCell
        cell.set(message: viewModel.getMessageAt(indexPath))
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ChatLogViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedCell = MessageCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedCell.set(message: viewModel.getMessageAt(indexPath))
        estimatedCell.layoutIfNeeded()
        let estimatedSize = estimatedCell.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: 1000))
        return CGSize(width: view.frame.width, height: estimatedSize.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}


// MARK: - Objc Methods
extension ChatLogViewController {
    
    @objc fileprivate func handleSend() {
        saveMessages()
        saveRecentMessages()
    }
    
    
    @objc fileprivate func handleBack() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    
    @objc fileprivate func handleKeyboardShow() {
        collectionView.scrollToItem(at: IndexPath(item: viewModel.getMessagesCount() - 1, section: 0), at: .bottom, animated: true)
    }
}


// MARK: - Methods
extension ChatLogViewController {
    
    fileprivate func saveRecentMessages() {
        viewModel.saveRecentMessages(message: messageInputView.textView.text) { status in print(status) }
    }
    
    
    fileprivate func saveMessages() {
        viewModel.saveMessages(message: messageInputView.textView.text) { [weak self] status in
            guard let self = self else { return }
            if status {
                self.messageInputView.textView.text = nil
                self.messageInputView.placeHolderLabel.isHidden = false
            }
        }
    }

    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    
    fileprivate func fetchMessages() {
        listener = viewModel.fetchMessages { [weak self] status in
            guard let self = self else { return }
            if status { self.updateUI() }
        }
    }
    
    
    fileprivate func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(item: self.viewModel.getMessagesCount() - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    
    fileprivate func setupLayout() {
        view.addSubview(customNavigationBar)
        customNavigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
        customNavigationBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        messageInputView.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
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
