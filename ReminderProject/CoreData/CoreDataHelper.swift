//
//  CoreDataHelper.swift
//  ReminderProject
//
//  Created by Green, Corey on 5/24/23.
//

import Foundation
import CoreData
import UIKit
import SwiftUI
import UserNotifications

class CoreDataHelper {
    
    static let shareInstance = CoreDataHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //func for creating and storing reminder ET in core data
    func createReminder(date: Date, title: String, notes: String, isRepeat: Int16) {
        let newReminder = ReminderEntity(context: context)
        newReminder.date =  date
        newReminder.title = title
        newReminder.notes = notes
        newReminder.isRepeat = isRepeat
        newReminder.id = UUID()
        scheduleLocalNotification(at: newReminder.date!.timeIntervalSince1970, reminderID: newReminder.id!, withTitle: newReminder.title!, andBody: newReminder.notes!, repeatInterval: Int(newReminder.isRepeat))
        do {
            try context.save()
        } catch {
            print("error saving \(newReminder)")
        }
    }
    //func for updating reminder ET
    func updateReminder(withId id: UUID, newDate: Date, newTitle: String, newNotes: String, updatedRepeat: Int16) {
        guard let reminder = CoreDataHelper.shareInstance.fetchReminderById(id) else {
            print("couldn't find reminder with \(id)")
            return
        }
        reminder.date = newDate
        reminder.title = newTitle
        reminder.notes = newNotes
        reminder.isRepeat = updatedRepeat
        
        do {
            try context.save()
        } catch {
            print("error updating \(reminder)")
        }
    }
    //func to delete reminder from core data
    func deleteReminder(reminder: ReminderEntity) {
        context.delete(reminder)
        do {
            try context.save()
        } catch {
            print("error deleting \(reminder)")
        }
    }
    //func to assist the function for updating a Reminder by ID
    func fetchReminderById(_ id: UUID) -> ReminderEntity? {
        let fetchRequest: NSFetchRequest<ReminderEntity> = ReminderEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch let error as NSError {
            print("couldn't find reminder, \(error.userInfo)")
            return nil
        }
    }
    //func to fetch all reminders by date and store them on the tableview
    func fetchReminders() -> [ReminderEntity] {
        var reminder: [ReminderEntity] = []
        
        let fetchRequest: NSFetchRequest<ReminderEntity> = ReminderEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            reminder = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("error fetching \(error)")
        }
        return reminder
    }
    
    func scheduleLocalNotification(at timestamp: TimeInterval, reminderID: UUID, withTitle title: String, andBody body: String, repeatInterval: Int) {
        let center = UNUserNotificationCenter.current()
        
        // Request permission to display notifications (if not already granted)
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                // Create a notification content
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default
                
                // Create a date component based on the provided timestamp
                let date = Date(timeIntervalSince1970: timestamp)
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                
                var trigger: UNNotificationTrigger
                
                switch repeatInterval {
                case 0:
                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                case 1:
                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                case 2:
                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 604800, repeats: true)
                case 3:
                    var weeklyComponents = DateComponents()
                    weeklyComponents.hour = dateComponents.hour
                    weeklyComponents.minute = dateComponents.minute
                    trigger = UNCalendarNotificationTrigger(dateMatching: weeklyComponents, repeats: true)
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)
                case 4:
                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1209600, repeats: true)
                case 5:
                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2592000, repeats: true)
                case 6:
                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 31536000, repeats: true)
                default:
                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                }
                
                // Create a notification request
                let uuidString = reminderID.uuidString //UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                
                // Schedule the notification
                center.add(request) { (error) in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    } else {
                        print("Notification scheduled successfully!")
                    }
                }
            } else {
                print("Notification permission not granted.")
            }
        }
    }
}
