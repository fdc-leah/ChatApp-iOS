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
