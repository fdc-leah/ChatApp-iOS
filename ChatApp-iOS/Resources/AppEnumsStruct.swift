//
//  AppEnumsStruct.swift
//  ChatApp-iOS
//
//  Created by Leah Joy Ylaya on 9/18/20.
//

import Foundation

enum SignInType: Int {
    case register = 1
    case login = 2
}

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
