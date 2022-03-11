//
//  AppleUserAuth.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/10/22.
//

import Foundation

class AppleUserAuth {
    
    static var isLoggedIn: Bool = false
    
    static func login() {
        AppleUserAuth.isLoggedIn = true
        print("AppleUserAuth is logged in")
    }
}
