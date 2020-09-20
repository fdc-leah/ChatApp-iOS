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
