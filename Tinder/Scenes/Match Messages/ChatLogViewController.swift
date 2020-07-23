import UIKit
import Firebase

class ChatLogViewController: UICollectionViewController {

    // MARK: Properties
    fileprivate var chatLogViewModel: ChatLogViewModel!
    fileprivate let navBarHeight: CGFloat = 120
    fileprivate lazy var customNavigationBar = ChatLogNavigationBar(chatLogViewModel: chatLogViewModel)
    fileprivate let statusBar = UIView()
    fileprivate lazy var messageInputView = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
    fileprivate var messages = [Message]()
    var currentUser: User?
    
    
    // MARK: Initializers
    init(chatLogViewModel: ChatLogViewModel) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.chatLogViewModel = chatLogViewModel
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
    
    @objc fileprivate func handleSend() {
        saveMessages()
        saveRecentMessages()
    }
    
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc fileprivate func handleKeyboardShow() {
        collectionView.scrollToItem(at: IndexPath(item: messages.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    
    fileprivate func saveRecentMessages() {  // TODO: refactor this code here
        if let message = messageInputView.textView.text, !message.isEmpty {
            guard let currentUserID = Auth.auth().currentUser?.uid else { return }
            let rootRef = Firestore.firestore().collection("matches_messages")
            let matchID = chatLogViewModel.uid
            
            let data: [String : Any] = [
                "uid": matchID,
                "name": chatLogViewModel.username,
                "profileImageUrl": chatLogViewModel.profileImageUrl,
                "text": messageInputView.textView.text ?? "",
                "timestamp": Timestamp(date: Date())
            ]
            
            let currentUserRef = rootRef.document(currentUserID).collection("recent_messages").document(matchID)
            currentUserRef.setData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("Recent message saved successfully in current user side")
            }
            
            let messageData: [String : Any] = [
                "uid": currentUserID,
                "name": currentUser?.name ?? "",
                "profileImageUrl": currentUser?.imageUrl1 ?? "",
                "text": messageInputView.textView.text ?? "",
                "timestamp": Timestamp(date: Date())
            ]
            
            let matchedUserRef = rootRef.document(matchID).collection("recent_messages").document(currentUserID)
            matchedUserRef.setData(messageData) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("Recent message saved successfully in matched user side")
            }
        }
    }
    
    
    fileprivate func saveMessages() {  // TODO: refactor this code here
        if let message = messageInputView.textView.text, !message.isEmpty {
            guard let currentUserID = Auth.auth().currentUser?.uid else { return }
            let matchID = chatLogViewModel.uid
            let rootRef = Firestore.firestore().collection("matches_messages")
            let currentUserRef = rootRef.document(currentUserID).collection(matchID)
            let documentData: [String : Any] = [
                "text" : message,
                "fromID": currentUserID,
                "toID": matchID,
                "timestamp": Timestamp(date: Date())
            ]
            
            currentUserRef.addDocument(data: documentData) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("current user message saved")
                self.messageInputView.textView.text = nil
                self.messageInputView.placeHolderLabel.isHidden = false
            }
            
            let matchUserRef = rootRef.document(matchID).collection(currentUserID)
            
            matchUserRef.addDocument(data: documentData) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("match user message saved")
                self.messageInputView.textView.text = nil
                self.messageInputView.placeHolderLabel.isHidden = false
            }
        }
    }
    
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    
    fileprivate func fetchMessages() { // TODO: Refactor this code
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let matchID = chatLogViewModel.uid
        let query = Firestore.firestore().collection("matches_messages").document(currentUserID).collection(matchID).order(by: "timestamp")
        
        query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let documentChanges = querySnapshot?.documentChanges else { return }
            for change in documentChanges {
                if change.type == .added {
                    self.messages.append(Message(dictionary: change.document.data()))
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: self.messages.count - 1, section: 0), at: .bottom, animated: true)
            }
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
