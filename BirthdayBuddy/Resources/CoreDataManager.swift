//
//  CoreDataManager.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/10/22.
//

import Foundation
import CoreData
import UIKit


class CoreDataManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    static let shared = CoreDataManager()
    var persons: [Person]
    
    init() {
        self.persons = []
        self.fetchPerson()
    }
    
    func fetchPerson() {
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            let sort = NSSortDescriptor(key: "daysLeft", ascending: true)
            request.sortDescriptors = [sort]
            
            self.persons = try context.fetch(request)
        } catch {
            print("Error fetching Person")
        }
    }
    
    func deleteAllBirthdays() {
        for person in self.persons {
            // remove person
            self.context.delete(person)
            // save data
            do {
                try self.context.save()
            } catch {
                print("Error deleting person")
            }
            // refetch data
            self.fetchPerson()
        }
    }
    
    /// returns the number of birthdays associated with an account
    func getNumberOfBirthdays() -> String{
        return "You have \(self.persons.count) birthdays on your account"
    }
    
    /// returns the number of birthdays for a specific month
    func getBirthdaysForMonth(month: Int) -> Int {
        self.fetchPerson()
        var numOfBirthdays = 0
        let calendar = Calendar.current
        for person in self.persons {
            guard let date = person.birthday else { fatalError() }
            let components = calendar.dateComponents([.month], from: date)
            if components.month == month {
                numOfBirthdays += 1
            }
        }
        return numOfBirthdays
    }
    
}
