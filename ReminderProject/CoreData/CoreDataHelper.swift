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
}
