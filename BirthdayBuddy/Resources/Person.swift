//
//  Person+CoreDataClass.swift
//  
//
//  Created by Max Park on 4/4/22.
//
//

import Foundation
import CoreData
import FirebaseDatabase

struct Person {
    var birthday: Date?
    var daysLeft: Int64
    var firstName: String?
    var lastName: String?
    var picture: Data?
    var id: UUID?
    var hasNotifications: Bool
    var pictureURL: String?
    var ref: DatabaseReference?
    
    func getDetails() {
        print("""
              Person Object Details:
              Name: \( self.firstName!) \(self.lastName ?? "")
              Birthday: \( self.birthday!.description)
              ID: \( self.id!)
              DaysLeft: \(self.daysLeft)
              Picture: \(self.picture ?? Data())
              """)
    }
    
    init(birthday: Date?, firstName: String?, lastName: String?, picture: Data?, id: UUID) {
        self.birthday = birthday
        self.firstName = firstName
        self.lastName = lastName
        self.picture = picture
        self.id = id
        self.hasNotifications = true
        self.daysLeft = 0
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        print(snapshot.key)
        guard
            let value = snapshot.value as? [String: AnyObject] else {
            print("error with value")
            return nil
        }
        guard
          let birthday = value["birthday"] as? Double else {
            print("error with birthday")
            return nil
        }
        guard
          let daysLeft = value["daysLeft"] as? Int64 else {
              print("error with daysleft")
              return nil
          }
        guard
          let firstName = value["firstName"] as? String else {
              print("error with firstname")
              return nil
          }
        guard
          let lastName = value["lastName"] as? String? else {
              print("error with lastname")
              return nil
          }
        guard
          let picture = value["picture"] as? Data? else {
              print("error with picture")
              return nil
          }
        guard
          let hasNotifications = value["hasNotifications"] as? Bool else {
            print("error with hasNotifications")
          return nil
        }

        self.birthday = Date(timeIntervalSince1970: birthday)
        self.daysLeft = daysLeft
        self.firstName = firstName
        self.lastName = lastName
        self.picture = picture
        self.id = UUID(uuidString: snapshot.key)
        self.hasNotifications = hasNotifications
        self.ref = snapshot.ref
    }
}
