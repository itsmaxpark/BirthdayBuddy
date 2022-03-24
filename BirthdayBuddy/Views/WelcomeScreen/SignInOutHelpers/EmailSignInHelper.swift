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
    
    func performCreateUser(firstName: String, lastName: String, email: String, password: String, view: WelcomeScreenButtonsView) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        Auth.auth().fetchSignInMethods(forEmail: email) { fetchResult, error in
            guard let providers = fetchResult, error == nil else { return }
            var providersBool = (Apple: false, Google: false)
            
            if !providers.isEmpty { // if credentials exist with apple/google ask user to link
                if providers.contains("apple.com") {
                    providersBool.Apple = true
                }
                if providers.contains("google.com"){
                    providersBool.Google = true
                }
                
                self.alertLinkProviders(providersBool, view: view)
                
                Auth.auth().addStateDidChangeListener({ auth, user in
                    auth.currentUser?.link(with: credential, completion: { linkResult, error in
                        guard error == nil else { return }
                        print("EmailSignInHelper: Providers successfully linked")
                        self.alertUserRegistered(view: view)
                    })
                })
                
            } else { // Alternate provider does not exists so create new user
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    guard let result = authResult, error == nil else {
                        print("EmailSignInHelper: Error creating a new user")
                        return
                    }
                    let userID = result.user.uid
                    DatabaseManager.shared.addUser(for: BirthdayBuddyUser(id: userID, firstName: firstName, lastName: lastName, emailAddress: email))
                    print("EmailSignInHelper: New user with id: \(userID) added to database")
                    self.alertUserRegistered(view: view)
                }
                
            }
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
    private func alertLinkProviders(_ providers: (Apple: Bool, Google: Bool), view: WelcomeScreenButtonsView) {
        var message = "This email is already associated with "
        switch (providers.Apple, providers.Google) {
        case (true, false):
            message += "Apple"
        case (false, true):
            message += "Google"
        case (true, true):
            message += "Apple and Google"
        default:
            message += ""
        }
        
        let alert = UIAlertController(title: "Link Accounts?", message: message, preferredStyle: .alert)
        
        if providers.Apple {
            alert.addAction(UIAlertAction(title: "Link account with Apple", style: .default, handler: { _ in
                AppleSignInHelper.shared.performSignIn(with: view)
            }))
        }
        if providers.Google {
            alert.addAction(UIAlertAction(title: "Link account with Google", style: .default, handler: { _ in
                GoogleSignInHelper.shared.performSignIn(with: view)
            }))
        }
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        alert.view.layoutIfNeeded()
        let vc = view.findViewController()
        vc?.present(alert, animated: true)
    }
    private func alertUserRegistered(view: WelcomeScreenButtonsView) {
        let alert = UIAlertController(title: "Awesome", message: "Your account was successfully created!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alert.view.layoutIfNeeded()
        let vc = view.findViewController()
        vc?.present(alert, animated: true)
    }
}
