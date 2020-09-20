//
//  DataManager.swift
//  ChatApp-iOS
//
//  Created by Leah Joy Ylaya on 9/19/20.
//

import Foundation
import FirebaseDatabase

final class DataManager {
    static let shared = DataManager()
    
    private let database = Database.database().reference()
    
    /// Insert user to DB
    public func linkUsernameEmail(with user: User, completion: @escaping(() -> Void)){
        // save email with username index to be used when logging in
        database.child("username-email-link").child("\(user.username)-email").setValue([
            user.username: user.email
        ])
        
        completion()
    }
    
    /// validate user if not existing
    public func validateUser(with username: String, completion: @escaping((Bool) -> Void)) {
        database.child("username-email-link/\(username)-email/\(username)").observeSingleEvent(of: .value) { (data) in
            if data.exists() {
                completion(true)
                return
            }
            completion(false)
        }
    }
    
    /// use to get number of users from db user
    public func getNumberOfUsers(completion: @escaping((Int) -> Void)) {
        database.child("username-email-link").observeSingleEvent(of: .value) { snap in
            completion(Int(snap.childrenCount))
        }
    }
    
    /// retreive email by username
    public func retreiveEmail(with username: String, completion: @escaping((String) -> Void)) {
        database.child("username-email-link/\(username)-email/\(username)").observeSingleEvent(of: .value, with: {(snap) in
            let userEmail = snap.value as? String ?? "" //returns email ID for the user.
             completion(userEmail)
        })
    }
}

// MARK: - Inserting and loading message
extension DataManager {
    func sendMessageToConversation(message: Message, completion: @escaping((Bool) -> Void)) {
        let newMessage = UserConversation.shared.createMessage(message: message)
        let rf = database.child("conversations")
        rf.observeSingleEvent(of: .value) { [weak self] (snap) in
            guard var conversationNode = snap.value as? [[String:Any]] else {
                self?.createConversation(with: newMessage) { (didSave) in
                    completion(didSave)
                }
                return
            }
            conversationNode.append(newMessage)
            rf.setValue(conversationNode) { (error, _) in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    func createConversation(with param: [String:Any], completion: @escaping((Bool) -> Void)) {
        database.child("conversations").setValue([param])
        completion(true)
    }
    
    func getAllConversation(completion: @escaping(Result<[Message],Error>) -> Void){
        database.child("conversations").observe(.value) { (snap) in
            guard let result = snap.value as? [[String: Any]] else {
                completion(.failure(ChatAppError.notFound))
                return
            }
            
            let messages: [Message] = result.compactMap { (dictionary) in
                guard let messageId = dictionary["message_id"] as? String ?? "",
                      let username = dictionary["username"] as? String ?? "",
                      let message = dictionary["message"] as? String ?? "",
                      let dateSent = dictionary["date_sent"] as? String ?? "",
                      let uid = dictionary["uid"] as? String ?? "" else {
                    completion(.failure(ChatAppError.invalidResponse))
                    return nil
                }
                return Message(sender: Sender(senderId: uid, displayName: username), messageId: messageId, sentDate: ChatAppUtility.getDate(dateStr: dateSent) ?? Date(), kind: .text(message))
            }
            completion(.success(messages))
        }
    }
    /// use to get number of users from db user
    func getNumberOfConversations(completion: @escaping((Int) -> Void)) {
        database.child("conversations").observeSingleEvent(of: .value) { snap in
            completion(Int(snap.childrenCount))
        }
    }
}
