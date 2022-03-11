//
//  SignOutHelper.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/11/22.
//

import Foundation
import FirebaseAuth

class SignOutHelper {
    
    static func signOut() {
        print("SignOutHelper: Signing the user out")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("SignOutHelper: Firebase sign out successful")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
