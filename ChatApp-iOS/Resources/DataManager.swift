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
    public func insertUser(with user: User){
        database.child(user.email).setValue([
            "username": user.username
        ])
    }
    
    /// validate user
    public func validateUser(with username: String, completion: @escaping((Bool) -> Void)) {
        database.child(username).observeSingleEvent(of: .value) { (data) in
            guard data.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}
