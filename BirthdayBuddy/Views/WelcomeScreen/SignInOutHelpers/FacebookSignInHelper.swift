//
//  FacebookSignInHelper.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/16/22.
//

import Foundation
import FBSDKLoginKit
import FirebaseAuth

class FacebookSignInHelper {
    
    static let shared = FacebookSignInHelper()
    
    func performSignIn(with view: WelcomeScreenButtonsView) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email","public_profile"], from: view.findViewController()) { result, error in
            guard error == nil, let token = result?.token?.tokenString else {
                print("FacebookSignInHelper: Encountered Error - \(String(describing: error))")
                return
            }
            guard let result = result, !result.isCancelled else {
                print("FacebookSignInHelper: Login Cancelled")
                return
            }
            let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
            
            facebookRequest.start { _, result, error in
                guard let result = result as? [String: Any], error == nil else {
                    print("FacebookSignInHelper: Failed to make facebook graph request")
                    return
                }
                guard let name = result["name"] as? String,
                      let email = result["email"] as? String else {
                    print("FacebookSignInHelper: Failed to fetch name and email")
                    return
                }
                let nameComponents = name.components(separatedBy: " ")
                guard nameComponents.count == 2 else { return }
                
                let firstName = nameComponents[0]
                let lastName = nameComponents[1]
                let credential = FacebookAuthProvider.credential(withAccessToken: token)
                
                Auth.auth().fetchSignInMethods(forEmail: email) { fetchResult, error in
                    guard let providers = fetchResult, error == nil else { return }

//                    var containsApple = false
//                    var containsGoogle = false
                    var providersBool = (Apple: false, Google: false)
                    
                    if !providers.contains("facebook.com") && !providers.isEmpty { // if credentials exist with apple/google ask user to link
                        //TODO: Add UIAlert for linking accounts
                        if providers.contains("apple.com") {
                            providersBool.Apple = true
                        }
                        if providers.contains("google.com"){
                            providersBool.Google = true
                        }
                        print(providersBool)
                        self.alertLinkProviders(providersBool, view: view)
                        
                        Auth.auth().addStateDidChangeListener({ auth, user in
                            auth.currentUser?.link(with: credential, completion: { linkResult, error in
                                guard error == nil else { return }
                                print("FacebookSignInHelper: Providers successfully linked")
                            })
                        })
                    } else { // Alternate provider does not exists so create new user
                        Auth.auth().signIn(with: credential) { authResult, error in
                            guard let result = authResult, error == nil else {
                                print(error)
                                return
                            }
                            let userID = result.user.uid
                            DatabaseManager.shared.addUser(for: BirthdayBuddyUser(id: userID, firstName: firstName, lastName: lastName, emailAddress: email))
                            WelcomeViewController.login()
                            print("FacebookSignInHelper: Logged In")
                        }
                    }
                }
            }
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
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alert.view.layoutIfNeeded()
        let vc = view.findViewController()
        vc?.present(alert, animated: true)
    }
}
