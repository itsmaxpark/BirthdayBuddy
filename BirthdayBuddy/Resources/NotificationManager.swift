//
//  NotificationManager.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/11/22.
//

import Foundation
import UserNotifications


class NotificationManager: ObservableObject {
  static let shared = NotificationManager()
  var settings: UNNotificationSettings?

    func createBirthdayNotification(person: Person) {
        // 1. Request User Authorization
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, _  in
        }
        
        // 2. Create Notification Content
        let content = UNMutableNotificationContent()
        let name = person.firstName!
        content.title = "It is \(name)'s birthday!"
        content.body = "Wish \(name) a Happy Birthday!"
        
        // 3. Create a notification trigger
        let date = self.configureNotificationTime(date: person.birthday!)
        print("Date: \(date)")
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // 4. Create a request
        guard let uuidString = person.id?.uuidString else { return }
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        // 5. Register the request
        center.add(request) { error in
            if let error = error {
                print("Error reistering request with Notification Center: \(error)")
            } else {
                print("NotificationManager: New Notification Created")
                print("Notifcation with id\(uuidString)")
            }
        }
    }
    func configureNotificationTime(date: Date) -> Date {
        let birthdayDateComponents = Calendar.current.dateComponents([.month, .day], from: date)
        var notificationDateComponents = DateComponents()
        
        notificationDateComponents.year = getCurrentYear()
        notificationDateComponents.month = birthdayDateComponents.month
        notificationDateComponents.day = birthdayDateComponents.day
        notificationDateComponents.hour = 8
        notificationDateComponents.minute = 0
        notificationDateComponents.second = 0
        
        var notificationDate = Calendar.current.date(from: notificationDateComponents)
        if notificationDate! < Date.now {
            // Set notification for the next year
            notificationDateComponents.year = getCurrentYear()+1
            notificationDate = Calendar.current.date(from: notificationDateComponents)
            print("Notification is set for next year")
        }
        
        return notificationDate!
    }
    func getCurrentYear() -> Int {
        return Calendar.current.component(.year, from: Date())
    }
    func getAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            print("There are \(requests.count) active notifications")
//            for request in requests {
//                print(request.trigger as Any)
//            }
        }
    }
}
