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
    
    func createReminder(date: Date, title: String, notes: String, isRepeat: Int16) {
        let newReminder = ReminderEntity(context: context)
        newReminder.date =  date
        newReminder.title = title
        newReminder.notes = notes
        newReminder.isRepeat = isRepeat
        newReminder.id = UUID()
    }
    func updateReminder(withId id: UUID, newDate: Date, newTitle: String, newNotes: String, updatedRepeat: Int16) {
        // TODO: Setup Update Reminder
//        guard let reminder = CoreDataHelper.shareInstance.fetchReminder() else {
//
//        }
        
    }
    func deleteReminder(reminder: ReminderEntity) {
        context.delete(reminder)
        do {
            try context.save()
        } catch {
            print("error deleting \(reminder)")
        }
    }
    
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

