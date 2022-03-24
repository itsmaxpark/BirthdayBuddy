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
    
    func performCreateUser(firstName: String, lastName: String, email: String, password: String, view: WelcomeScreenButtonsView, completion: @escaping () -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
 
        Auth.auth().fetchSignInMethods(forEmail: email) { result, error in
            print("EmailSignInHelper: Fetching sign in methods")
            
            guard error == nil else {
                print("Inside guard")
                print("Error: \(String(describing: error))")
                if let error = error as NSError? {
                    print("Inside error as nserror")
                    if let errorCode = AuthErrorCode(rawValue: error.code) {
                        switch errorCode {
                        case .invalidEmail:
                            print("invalidEmail")
                        case .accountExistsWithDifferentCredential:
                            print("accountExistsWithDifferentCredential")
                        case .emailAlreadyInUse:
                            print("emailAlreadyInUse")
                        case .invalidRecipientEmail:
                            print("invalidRecipientEmail")
                        case .weakPassword:
                            print("weakPassword")
                        default:
                            print(errorCode)
                        }
                    }
                    print("No error")
                }
                return
            }
            guard let providers = result else { // providers is empty so create new user
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    print("EmailSignInHelper: Creating new user")
                    guard let result = authResult, error == nil else {
                        print("EmailSignInHelper: Error creating a new user")
                        return
                    }
                    let userID = result.user.uid
                    DatabaseManager.shared.addUser(for: BirthdayBuddyUser(id: userID, firstName: firstName, lastName: lastName, emailAddress: email))
                    print("EmailSignInHelper: New user with id: \(userID) added to database")
                    completion()
                }
                return
            }
            var providersBool = (Apple: false, Google: false)
            
            // if credentials exist with apple/google ask user to link
            if providers.contains("apple.com") {
                providersBool.Apple = true
            }
            if providers.contains("google.com"){
                providersBool.Google = true
            }
            
            self.alertLinkProviders(providersBool, view: view) {
                Auth.auth().addStateDidChangeListener({ auth, user in
                    auth.currentUser?.link(with: credential, completion: { linkResult, error in
                        guard error == nil else { return }
                        print("EmailSignInHelper: Providers successfully linked")
                        completion()
                    })
                })
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
    private func alertLinkProviders(_ providers: (Apple: Bool, Google: Bool), view: WelcomeScreenButtonsView, completion: @escaping ()->Void ) {
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
                completion()
            }))
        }
        if providers.Google {
            alert.addAction(UIAlertAction(title: "Link account with Google", style: .default, handler: { _ in
                GoogleSignInHelper.shared.performSignIn(with: view)
                completion()
            }))
        }
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in
            completion()
        }))
        alert.view.layoutIfNeeded()
        let vc = view.findViewController()
        vc?.present(alert, animated: true)
    }
}
