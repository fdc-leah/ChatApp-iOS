//
//  UserConversation.swift
//  ChatApp-iOS
//
//  Created by Leah Joy Ylaya on 9/20/20.
//

import Foundation
import MessageKit

class UserConversation {
    static let shared = UserConversation()
    func createMessage(message: Message) -> [String : Any] {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let now = df.string(from: message.sentDate)
        return [
            "message_id": message.messageId,
            "username": message.sender.displayName,
            "message": message.kind.messageContent,
            "date_sent": now,
            "uid": message.sender.senderId
        ]
        
        
    }
}
