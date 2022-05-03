//
//  DatabaseManager.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/10/22.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class DatabaseManager {
    static let shared = DatabaseManager()
    public let database = Database.database().reference()
    public let usersRef = Database.database().reference().child("users")
    public let storageRef = Storage.storage().reference()
    public let storage = Storage.storage()
}
// MARK: - Account Management

extension DatabaseManager {
    /// Insert new user to database
    public func addUser(for user: BirthdayBuddyUser) {
        usersRef.child(user.id).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
            "email": user.emailAddress
        ])
    }
    
    public func addBirthday(for person: Person) {
        guard let uid = Auth.auth().currentUser?.uid else {
            fatalError("Unable to retrieve current user uid")
        }
        // users -> current user uid -> birthdays -> person
        let birthdaysRef = usersRef.child("\(uid)/birthdays/\(person.id as AnyObject)")
        
        // Convert NSDate to Double Interval
        let personBirthday = person.birthday?.timeIntervalSince1970
        
        // Add person to database
        birthdaysRef.setValue([
            "birthday": personBirthday as AnyObject,
            "daysLeft": person.daysLeft as AnyObject,
            "firstName": person.firstName as AnyObject,
            "lastName": person.lastName as AnyObject,
            "hasNotifications": person.hasNotifications as AnyObject,
            "pictureURL" : " "
        ])
        
        guard let imageData = person.picture else {
            print("Unable to retrieve image data")
            birthdaysRef.child("pictureURL").setValue(nil)
//            birthdaysRef.setValue(["pictureURL": nil])
            return
        }
//        imageRef.putData(imageData) { snapshot in
//            // When the image has successfully uploaded, we get it's download URL
//            snapshot.reference.downloadURL { url, error in
//                if error != nil {
//                    fatalError("Error retrieving download url")
//                }
//                // Write the download URL to the Realtime Database
//                birthdaysRef.child("pictureURL").setValue(url?.absoluteString)
//                print("PutData ")
//            }
//        }
        // Save Image reference to Cloud Storage
        guard let personID = person.id else { return }
        let imageRef = storageRef.child("pictures/\(uid)/\(personID).jpg")
        print(imageRef)
        print("Putting data image")
        let uploadTask = imageRef.putData(imageData, metadata: nil) { metedata, error in
            print("Inside putting image data")
            if error != nil {
                print(error?.localizedDescription as Any)
                fatalError("Error saving image to firebase")
            }
            imageRef.downloadURL { url, error in
                if error != nil {
                    fatalError("Error retrieving download url")
                }
                guard let url = url else { return }
                birthdaysRef.child("pictureURL").setValue(url.absoluteString)
                print("saved picture url to birthday path")
            }
        }
    }
}


