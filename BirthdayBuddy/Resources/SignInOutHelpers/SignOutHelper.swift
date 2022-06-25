//
//  SignOutHelper.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/11/22.
//

import Foundation
import FirebaseAuth
import UIKit
import FBSDKLoginKit

class SignOutHelper {
    
    static func signOut() {
        print("SignOutHelper: Signing the user out")
        let firebaseAuth = Auth.auth()
        
        if let providerData = Auth.auth().currentUser?.providerData {
                for userInfo in providerData {
                    switch userInfo.providerID {
                    case "facebook.com":
                        FBSDKLoginKit.LoginManager().logOut()
                        print("user is signed out with facebook")
                    case "google.com":
                        print("user is signed out with google")
                    case "apple.com":
                        UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
                        print("user is signed out with apple")
                    default:
                        print("user is signed out with \(userInfo.providerID)")
                    }
                }
            }
        
        // Facebook Log Out
        
        // Apple Log Out
        
        // Firebase Auth Log Out
        do {
            try firebaseAuth.signOut()
            print("SignOutHelper: Firebase sign out successful")
            WelcomeVC.isLoggedIn = false
            let vc = TabBarVC()
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            vc.presentWelcomeVC()
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
