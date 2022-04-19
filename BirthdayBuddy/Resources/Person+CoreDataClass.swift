//
//  Person+CoreDataClass.swift
//  
//
//  Created by Max Park on 4/4/22.
//
//

import Foundation
import CoreData

@objc(Person)
public class Person: NSManagedObject {
    func getDetails() {
        print("""
              Person Object Details:
              \(String(describing: self.firstName)) \(self.lastName ?? "")
              \(String(describing: self.birthday?.description))
              \(String(describing: self.id))
              \(self.daysLeft)
              """)
    }
}
