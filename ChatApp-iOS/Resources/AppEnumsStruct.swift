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
}
