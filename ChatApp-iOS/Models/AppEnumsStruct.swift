//
//  AppEnumsStruct.swift
//  ChatApp-iOS
//
//  Created by Leah Joy Ylaya on 9/18/20.
//

import Foundation
import MessageKit

enum SignInType: Int {
    case register = 1
    case login = 2
}

enum ChatAppError: Error {
    case unknownError
    case connectionError
    case invalidCredentials
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case timeOut
    case unsuppotedURL
 }

// Default app font weight
enum FontWeight: String {
    case bold = "-Bold"
    case regular = ""
    case italic = "-Italic"
    case boldItalic = "-BoldItalic"
}


// These error codes are Firebase codes grouped according to its description
enum AuthErrorType {
    case username
    case password
    case generalError
    
    static func getErrorType(code: Int) -> AuthErrorType {
        let usernameErrorArr = [17004,17005,17006,17007,17008,17011,17012,17025]
        let passErrorArr = [17026,17009,17006,17007,17008,17011,17012,17025]
        if usernameErrorArr.contains(code) {
            return .username
        } else if passErrorArr.contains(code) {
            return .password
        } else {
            return .generalError
        }
    }
}

struct User {
    var username: String
    var email: String
    var uid: String
    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

struct Message: MessageType, Equatable {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
    
    static func == (lhs: Message, rhs: Message) -> Bool {
      return lhs.sentDate == rhs.sentDate
    }
}

extension MessageKind {
    var messageContent: String {
        switch self {
        case .text(let message):
            return message
        case .attributedText(_):
            return "attributedText"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "linkPreview"
        case .custom(_):
            return "custom"
        }
    }
}

struct Sender: SenderType {
    public var senderId: String
    public var displayName: String
}
