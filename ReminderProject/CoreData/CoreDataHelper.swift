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
    let defaults = UserDefaults.standard
    
    //func for creating and storing reminder ET in core data
    // Adding ID as a param so IDs in core data and AWS DB match up
    func createReminder(date: Date, title: String, notes: String, isRepeat: Int16) {
        let newReminder = ReminderEntity(context: context)
        newReminder.date =  date
        newReminder.title = title
        newReminder.notes = notes
        newReminder.isRepeat = isRepeat
        newReminder.id = UUID()
        
        let localData = defaults.string(forKey: "versionType")
        print("local data: \(localData!)")
        if (localData == "Local") {
            scheduleLocalNotification(at: newReminder.date!.timeIntervalSince1970, reminderID: newReminder.id!, withTitle: newReminder.title!, andBody: newReminder.notes!, repeatInterval: Int(newReminder.isRepeat))
        } else {
            addReminderHosted(id: newReminder.id!.uuidString,
                        reminderDate: date,
                        reminderTitle: title,
                        reminderNotes: notes,
                        isRepeat: -1)
        }
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
        
        let localData = defaults.string(forKey: "versionType")
        
        if (localData == "Local")
        {
          editScheduledNotification(at: reminder.date!.timeIntervalSince1970, reminderID: reminder.id!, withTitle: reminder.title!, andBody: reminder.notes!, repeatInterval: Int(reminder.isRepeat))
        }
        do {
            try context.save()
        } catch {
            print("error updating \(reminder)")
        }
    }
    
    //func to delete reminder from core data
    func deleteReminder(reminder: ReminderEntity) {
        context.delete(reminder)
        
        let localData = defaults.string(forKey: "versionType")
        
        if (localData == "Local") {
            deleteScheduledNotification(reminderID: reminder.id!)
        } else {
            print(reminder.id!.uuidString)
            deleteRemindersHosted(id: reminder.id!.uuidString)
        }
        
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
    
    func convertData(to versionType: String) {
        let localData = defaults.string(forKey: "versionType")

        if versionType == "Local" && localData == "Hosted" {
            // Convert from Hosted to Local
            let hostedReminders = fetchReminders()

            for reminder in hostedReminders {
                scheduleLocalNotification(at: reminder.date!.timeIntervalSince1970, reminderID: reminder.id!, withTitle: reminder.title!, andBody: reminder.notes!, repeatInterval: Int(reminder.isRepeat))
            }

           // Delete all hosted reminders
            for reminder in hostedReminders {
                deleteRemindersHosted(id: reminder.id!.uuidString)
            }
        } else if versionType == "Hosted" && localData == "Local" {
            // Convert from Local to Hosted
            let localReminders = fetchReminders()

           for reminder in localReminders {
                addReminderHosted(id: reminder.id!.uuidString,
                                  reminderDate: reminder.date!,
                                  reminderTitle: reminder.title!,
                                  reminderNotes: reminder.notes!,
                                  isRepeat: Int(reminder.isRepeat))
            }
            
           // Delete all scheduled local notifications
            for reminder in localReminders {
                deleteScheduledNotification(reminderID: reminder.id!)
            }
        }
       // Update UserDefaults with the new versionType
        defaults.set(versionType, forKey: "versionType")
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
    func deleteScheduledNotification(reminderID: UUID) {
        let center = UNUserNotificationCenter.current()
        
        // Remove the notification with the specified identifier
        let uuidString = reminderID.uuidString
        center.removePendingNotificationRequests(withIdentifiers: [uuidString])
    }
    
    func editScheduledNotification(at timestamp: TimeInterval, reminderID: UUID, withTitle title: String, andBody body: String, repeatInterval: Int) {
        let center = UNUserNotificationCenter.current()
        
        // Remove the existing notification with the specified identifier
        let uuidString = reminderID.uuidString
        center.removePendingNotificationRequests(withIdentifiers: [uuidString])
        
        // Schedule the updated notification using the provided parameters
        scheduleLocalNotification(at: timestamp, reminderID: reminderID, withTitle: title, andBody: body, repeatInterval: repeatInterval)
    }

}
