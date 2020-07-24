import UIKit
import Firebase

class MatchMessagesViewController: UICollectionViewController {

    // MARK: Properties
    fileprivate let navBarHeight: CGFloat = 130
    fileprivate let matchMessagesViewModel = MatchMessagesViewModel()
    fileprivate let customNavBar = MatchMessagesNavigationBar()
    fileprivate let statusBar = UIView()
    fileprivate var recentMessages = [RecentMessage]()
    fileprivate var recentMessagesDictionary = [String : RecentMessage]()
    fileprivate var listener: ListenerRegistration?
    var currentUser: User?
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
//        fetchRecentMessages()
        fetchData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent { listener?.remove() }
    }
}


// MARK: - Collection View Datasource
extension MatchMessagesViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentMessages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentMessageCell.reuseID, for: indexPath) as! RecentMessageCell
        cell.set(recentMessage: recentMessages[indexPath.item])
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MatchesHeaderView.reuseID, for: indexPath) as! MatchesHeaderView
        headerView.matchesController.rootMatchesController = self
        return headerView
    }
}


// MARK: - Collection View Delegate
extension MatchMessagesViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToChatLog(chatLogViewModel: recentMessages[indexPath.item].toChatLogViewModel())
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MatchMessagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 130)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 250)
    }
}


// MARK: - Methods
extension MatchMessagesViewController {
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func didSelectMatchFromHeader(match: Match) {
        navigateToChatLog(chatLogViewModel: match.toChatLogViewModel())
    }
    
    
//    fileprivate func fetchRecentMessages() { // TODO: Refactor this code
//        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
//        let reference = Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages")
//        listener = reference.addSnapshotListener { [weak self] querySnapshot, error in
//            guard let self = self else { return }
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            guard let documentChanges = querySnapshot?.documentChanges else { return }
//            for change in documentChanges {
//                if change.type == .added || change.type == .modified {
//                    let recentMessage = RecentMessage(dictionary: change.document.data())
//                    self.recentMessagesDictionary[recentMessage.uid ?? ""] = recentMessage
//                }
//            }
//            self.resetRecentMessages()
//        }
//    }
    
    
    fileprivate func fetchData() {
        listener = matchMessagesViewModel.fetchRecentMessages(completion: { [weak self] recentMessages in
            guard let self = self, let recentMessages = recentMessages else { return }
            self.recentMessages = recentMessages
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    
//    fileprivate func resetRecentMessages() {
//        let values = Array(recentMessagesDictionary.values)
//        recentMessages = values.sorted(by: { (recentMessage1, recentMessage2) -> Bool in
//            guard let timestamp1 = recentMessage1.timestamp, let timestamp2 = recentMessage2.timestamp else { return false }
//            return timestamp1.compare(timestamp2) == .orderedDescending
//        })
//        collectionView.reloadData()
//    }
    
    
    fileprivate func navigateToChatLog(chatLogViewModel: ChatLogViewModel) {
        let controller = ChatLogViewController(chatLogViewModel: chatLogViewModel)
        controller.currentUser = currentUser
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = navBarHeight
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
        collectionView.register(RecentMessageCell.self, forCellWithReuseIdentifier: RecentMessageCell.reuseID)
        collectionView.register(MatchesHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MatchesHeaderView.reuseID)
    }
    
    
    fileprivate func setupLayout() {
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        statusBar.backgroundColor = .white
        view.addSubview(statusBar)
        statusBar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
}
