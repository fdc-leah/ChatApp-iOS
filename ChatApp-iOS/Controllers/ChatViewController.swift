//
//  ChatViewController.swift
//  ChatApp-iOS
//
//  Created by Leah Joy Ylaya on 9/18/20.
//

import UIKit
import FirebaseAuth
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    private var messages: [Message] = []
//    private var messageListener: ListenerRegistration?
    private var ownSender: Sender? {
        guard !UserData.shared.uid.isEmpty else {
            return nil
        }
        return Sender(senderId: UserData.shared.uid, displayName: UserData.shared.username)
    }
    deinit {
        debugPrint("ChatViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        setupAppearance()
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
          layout.setMessageIncomingAvatarSize(.zero)
          layout.setMessageOutgoingAvatarSize(.zero)
        }
        messageListener()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }

    @objc func logoutUser(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            UserData.shared.clear { [weak self] in
                self?.showViewController(with: "signupLogin")
            }
        }catch {
            debugPrint("already logged out")
            showViewController(with: "signupLogin")
            
        }
    }
    
    func setupAppearance() {
        title = "Chat app"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font : ChatAppUtility.defaultAppFont(weight: .bold, fontSize: 20)]
        
        navigationItem.setHidesBackButton(true, animated: true)
        let linkAtrribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font : ChatAppUtility.defaultAppFont(fontSize: 14)]
            
        let attributedStr = NSMutableAttributedString(string: "Log out", attributes: linkAtrribute)
        
        // Add logout button on right bar
        let btnLogout = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 25))
        btnLogout.setAttributedTitle(attributedStr, for: .normal)
        btnLogout.backgroundColor = UIColor(hexString: "666666")
        btnLogout.layer.cornerRadius = 4
        btnLogout.layer.masksToBounds = true
        btnLogout.addTarget(self, action: #selector(logoutUser(_:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: btnLogout)
        navigationItem.rightBarButtonItem = rightBarButton
        
        messageInputBar.sendButton.backgroundColor = UIColor(hexString: "666666")
        messageInputBar.sendButton.setTitleColor(.white, for: .normal)
        ChatAppUtility.applyRoundedCorners(view: messageInputBar.sendButton, cornerRadius: 8)
        messageInputBar.inputTextView.placeholder = "Start a new message"
        
    }
   
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        messagesCollectionView.reloadDataAndKeepOffset()
        if messages.firstIndex(of: message) == (messages.count - 1) {
            messagesCollectionView.scrollToBottom()
        }
    }
    
    private func messageListener() {
        DataManager.shared.getAllConversation { [weak self] result in
            guard let newSelf = self else {
                return
            }
            switch result {
            case .success(let messageResult):
                guard !messageResult.isEmpty else {
                    return
                }
                newSelf.messages = messageResult
                break
            case .failure(_):
                break
            }
            DispatchQueue.main.async {
                newSelf.messagesCollectionView.reloadData()
            }
        }
    }

}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = ownSender {
            return sender
        }
        return Sender(senderId: "nil", displayName: "nil")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor(hexString: "88E402")
    }

    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
       
        return .bubbleTail(corner, .pointedEdge)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }

    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }

    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }

    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {

        return messages[indexPath.section]
    }
    
    // used for showing the name of the sender
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let sender =  messages[indexPath.section].sender
        let style = NSMutableParagraphStyle()
        style.alignment = sender.senderId == UserData.shared.uid ? .right : .left
        let bottomAttribute: [NSAttributedString.Key: Any] = [
            .font : ChatAppUtility.defaultAppFont(fontSize: 10),
            .foregroundColor: UIColor.init(hexString: "666666"),
            .paragraphStyle: style]
        return NSAttributedString(string: messages[indexPath.section].sender.displayName, attributes: bottomAttribute)
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }

    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {

        let name = message.sender.displayName
        return NSAttributedString(string: name,
                                  attributes: [
                                    .font: UIFont.preferredFont(forTextStyle: .caption1),
                                    .foregroundColor: UIColor(white: 0.3, alpha: 1)])
    }
    
    
    // create message ID using date and random numbers
    private func createMessageID() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy_HH-mm"
        let newDate = dateFormatter.string(from: Date())
        let number = Int.random(in: 0...1000)
        return newDate + "_\(number)"
    }
}


extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let sender = ownSender else {
            return
        }
        
        let message = Message(sender: sender, messageId: createMessageID(), sentDate: Date(), kind: .text(text))
        DataManager.shared.sendMessageToConversation(message: message) { [weak self] (isSent) in
            guard let newSelf = self else {
                return
            }
            if isSent {
                newSelf.messageInputBar.inputTextView.text = ""
                newSelf.insertNewMessage(message)
            }
        }
    }
}
