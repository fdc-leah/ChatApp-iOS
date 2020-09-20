//
//  UserData.swift
//  ChatApp-iOS
//
//  Created by Leah Joy Ylaya on 9/20/20.
//

import Foundation

class UserData {
    static let shared = UserData()
    
    var uid: String = ""
    var username: String = ""
    var email: String = ""
    
    
    func clear(completion: @escaping(()->Void)){
        uid = ""
        username = ""
        email = ""
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        completion()
    }
    
    func set(dictionary dict: [String: Any]) {
        UserData.shared.uid = dict["uid"] as? String ?? ""
        UserData.shared.username = dict["username"] as? String ?? ""
        UserData.shared.email = dict["email"] as? String ?? ""
        let userInfo = [
            "uid" : uid,
            "username" : username,
            "email" : email] as [String:Any]
        
        UserDefaults.standard.setValue(userInfo, forKey: "user_information")
        UserDefaults.standard.synchronize()
    }
    
    func setInfoByDefault(completion: @escaping(()->Void)) {
        //MARK: - if has no stored viewer information
        if UserDefaults.standard.value(forKey: "user_information") == nil {
            return
        }
        
        //MARK: - get user information
        guard
            let dict = UserDefaults.standard.value(forKey: "user_information") as? [String: Any]
            else {
                return
        }
        //MARK: - set broadcaster data
        self.set(dictionary: dict)
        completion()
    }
}
