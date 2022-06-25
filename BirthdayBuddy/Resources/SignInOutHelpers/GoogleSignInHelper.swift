//
//  GoogleSignInHelper.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/22/22.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

class GoogleSignInHelper {
    
    static let shared = GoogleSignInHelper()
    
    func performSignIn(with view: WelcomeScreenButtonsView) {
        
        let signInConfig = GIDConfiguration.init(clientID: "380171286570-8qr83svostrn47hv67ct9vele23od8i8.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: view.findViewController()!) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            user.authentication.do { authentication, error in
                guard error == nil else { return }
                guard let authentication = authentication else { return }
                guard let idToken = authentication.idToken else { return }
                let accessToken = authentication.accessToken
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    
                    guard let result = authResult, error == nil else {
                        print("GoogleSignInHelper: Error creating a new user")
                        return
                    }
                    let userID = result.user.uid
                    
                    guard let email = user.profile?.email else { return }
                    guard let name = user.profile?.name else { return }
                    
                    let nameComponents = name.components(separatedBy: " ")
                    guard nameComponents.count == 2 else {
                        return
                    }
                    let firstName = nameComponents[0]
                    let lastName = nameComponents[1]
                    
                    Auth.auth().fetchSignInMethods(forEmail: email) { providers, error in
                        if error != nil {
                            print(error?.localizedDescription as Any)
                        }
                        if let providers = providers, providers.contains("google.com") {
                            DatabaseManager.shared.addUser(for: BirthdayBuddyUser(id: userID, firstName: firstName, lastName: lastName, emailAddress: email))
                        } else {
                            fatalError()
                        }
                        
                    }
                    
                    
                    WelcomeVC.login()
                    print("GoogleSignInHelper: Logged In")
                }
            }
        }
    }
}
