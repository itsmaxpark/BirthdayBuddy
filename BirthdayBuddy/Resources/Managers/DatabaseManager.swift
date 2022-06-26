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
        database.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(user.id){
                print("Account already exists")
            } else {
                print("Account does not exist")
                self.usersRef.child(user.id).setValue([
                    "first_name": user.firstName,
                    "last_name": user.lastName,
                    "email": user.emailAddress
                ])
            }
        })
    }
    
    public func addBirthday(for person: Person, completion: @escaping ((Result<Void, Error>) -> Void)) {
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
            print("New person has no picture")
            birthdaysRef.child("pictureURL").setValue(nil)
            completion(.success(()))
            return 
        }
        // Save Image reference to Cloud Storage
        guard let personID = person.id else { return }
        let imageRef = storageRef.child("pictures/\(uid)/\(personID).jpg")
        imageRef.putData(imageData, metadata: nil) { metedata, error in
            if let error = error {
                completion(.failure(error))
            }
            imageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard let url = url else { return }
                print("addBirthday: Setting picture URL value")
                birthdaysRef.child("pictureURL").setValue(url.absoluteString)
                completion(.success(()))
                print("addBirthday: saved picture url to birthday path")
            }
        }
    }
    
    public func updateBirthday(for person: Person, completion: @escaping ((Result<Void, Error>) -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid else {
            fatalError("Unable to retrieve current user uid")
        }
        // users -> current user uid -> birthdays -> person
        let birthdaysRef = usersRef.child("\(uid)/birthdays/\(person.id as AnyObject)")
        // Convert NSDate to Double Interval
        let personBirthday = person.birthday?.timeIntervalSince1970
        // Add person to database
        birthdaysRef.updateChildValues([
            "birthday": personBirthday as AnyObject,
            "daysLeft": person.daysLeft as AnyObject,
            "firstName": person.firstName as AnyObject,
            "lastName": person.lastName as AnyObject,
            "hasNotifications": person.hasNotifications as AnyObject,
            "pictureURL" : " "
        ])
        guard let imageData = person.picture else {
            birthdaysRef.updateChildValues(["pictureURL" : nil])
            completion(.success(()))
            return
        }
        // Save Image reference to Cloud Storage
        guard let personID = person.id else { return }
        let imageRef = storageRef.child("pictures/\(uid)/\(personID).jpg")
        imageRef.delete()
        imageRef.putData(imageData, metadata: nil) { metedata, error in
            if let error = error {
                completion(.failure(error))
            }
            imageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard let url = url else { return }
                birthdaysRef.updateChildValues(["pictureURL" : url.absoluteString])
                completion(.success(()))
                print("saved picture url to birthday path")
            }
        }
    }
    
    public func deletePicture(for person: Person) {
        guard let uid = Auth.auth().currentUser?.uid else {
            fatalError("Unable to retrieve current user uid")
        }
        guard let personID = person.id else { return }
        let imageRef = storageRef.child("pictures/\(uid)/\(personID).jpg")
        imageRef.delete()
        
    }
    
    func fetchPerson(_ completion: @escaping (([Person]) -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var newPersons: [Person] = []
        let birthdayRef = DatabaseManager.shared.usersRef.child("\(uid)/birthdays")
        
        birthdayRef
            .queryOrdered(byChild: "daysLeft")
            .observeSingleEvent(of: .value) { snapshot in
                let group = DispatchGroup()
                
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot, var person = Person(snapshot: snapshot) {
                        group.enter()
                        print(person)
                        self.fetchPicture(for: person) { data in
                            person.picture = data
                            newPersons.append(person)
                            group.leave()
                        }
                    } else {
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    newPersons.sort(by: { $0.daysLeft < $1.daysLeft })
                    completion(newPersons)
                }
            }
    }
    
    func fetchPicture(for person: Person, completion: @escaping ((Data?) -> Void)) {
        guard let personID = person.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var imageData: Data?
        let birthdayRef = DatabaseManager.shared.usersRef.child("\(uid)/birthdays")
        
        birthdayRef.child("\(personID)/pictureURL").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                guard let urlString = snapshot.value as? String else { return }
                guard let url = URL(string: urlString) else { return }
                
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    
                    imageData = data
                    completion(imageData)
                }
                task.resume()
            } else {
                completion(nil)
            }
        }
    }
}


