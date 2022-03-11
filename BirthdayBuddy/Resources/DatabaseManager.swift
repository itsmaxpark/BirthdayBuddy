//
//  DatabaseManager.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/10/22.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    public func addUser(for user: BirthdayBuddyUser) {
        database.child(user.emailAddress).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}


