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
    
    func performCreateUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let result = authResult, error == nil else {
                print("didTapRegister: Error creating a new user")
                return
            }
            let user = result.user
            print("didTapRegister: User successfully created - \(user)")
        }
    }
    
    func performSignIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            guard let strongSelf = self else { return }
            guard let result = authResult, error == nil else {
                print("performSignIn: Error creating user")
                return
            }
            
            let user = result.user
            print("didTapSignIn: User successfully signed In - \(user)")
            
            WelcomeViewController.login()
            print("Signing in using Email Credentials")
        }
        
    }
}
