//
//  EmailSignInHelper.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/10/22.
//

import Foundation
import FirebaseAuth

class EmailSignInHelper {
    
    static let shared = EmailSignInHelper()
    
    func performCreateUser(firstName: String, lastName: String, email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let result = authResult, error == nil else {
                print("EmailSignInHelper: Error creating a new user")
                return
            }
            let userID = result.user.uid
            DatabaseManager.shared.addUser(for: BirthdayBuddyUser(id: userID, firstName: firstName, lastName: lastName, emailAddress: email))
            print("EmailSignInHelper: New user with id: \(userID) added to database")
        }
    }
    
    func performSignIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            guard let result = authResult, error == nil else {
                print("EmailSignInHelper: Error signing in user")
                return
            }
            
            let userID = result.user.uid
            print("EmailSignInHelper: User successfully signed In - \(userID)")
        
            WelcomeViewController.login()
            print("EmailSignInHelper: Signing in using Email Credentials")
        }
        
    }
}
