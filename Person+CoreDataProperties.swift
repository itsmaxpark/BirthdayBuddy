//
//  Person+CoreDataProperties.swift
//  
//
//  Created by Max Park on 4/30/22.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var daysLeft: Int64
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var picture: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var hasNotifications: Bool

}
