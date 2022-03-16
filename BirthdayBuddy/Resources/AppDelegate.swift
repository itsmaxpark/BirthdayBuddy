//
//  AppDelegate.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseConfiguration().setLoggerLevel(FirebaseLoggerLevel.min)
        FirebaseApp.configure()
        
        if let user = Auth.auth().currentUser {
            print("You have signed back in as \(user.uid) using \(user.email ?? "Unknown Email")")
            WelcomeViewController.login()
        }
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}

