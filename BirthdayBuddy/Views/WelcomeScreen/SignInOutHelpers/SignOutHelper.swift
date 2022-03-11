//
//  SignOutHelper.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/11/22.
//

import Foundation
import FirebaseAuth
import UIKit

class SignOutHelper {
    
    static func signOut() {
        print("SignOutHelper: Signing the user out")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("SignOutHelper: Firebase sign out successful")
            WelcomeViewController.isLoggedIn = false
            let vc = TabBarViewController()
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            vc.presentWelcomeVC()
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
