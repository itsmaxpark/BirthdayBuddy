//
//  DatabaseManager.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/10/22.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    private let usersRef = Database.database().reference().child("users")
}
// MARK: - Account Management

extension DatabaseManager {
    /// Insert new user to database
    public func addUser(for user: BirthdayBuddyUser) {
        usersRef.child(user.id).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
            "email": user.emailAddress
        ])
    }
    
    public func addBirthday(for person: Person) {
        guard let uid = Auth.auth().currentUser?.uid else {
            fatalError("Unable to retrieve current user uid")
        }
        // users -> current user uid -> birthdays -> person
        let birthdaysRef = usersRef.child("\(uid)/birthdays/\(person.id as AnyObject)")
        // Convert NSDate to Double Interval
        let personBirthday = person.birthday?.timeIntervalSince1970
        birthdaysRef.setValue([
            "birthday": personBirthday as AnyObject,
            "daysLeft": person.daysLeft as AnyObject,
            "firstName": person.firstName as AnyObject,
            "lastName": person.lastName as AnyObject,
            "picture": person.picture as AnyObject,
            "hasNotifications": person.hasNotifications as AnyObject
        ])
    }
}


