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

                    if !providers.contains("facebook.com") {
                        //TODO: Add UIAlert for linking accounts
                        GoogleSignInHelper.shared.performSignIn(with: view)
                        
                        Auth.auth().addStateDidChangeListener({ auth, user in
                            auth.currentUser?.link(with: credential, completion: { linkResult, error in
                                guard error == nil else { return }
                                print("FacebookSignInHelper: Providers successfully linked")
                            })
                        })
                    } else { // Alternate provider does not exists so create new user
                        Auth.auth().signIn(with: credential) { authResult, error in
                            guard let result = authResult, error == nil else { return }
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
}
