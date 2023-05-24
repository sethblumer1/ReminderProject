//
//  ReminderEntity+CoreDataProperties.swift
//  ReminderProject
//
//  Created by Green, Corey on 5/24/23.
//
//

import Foundation
import CoreData


extension ReminderEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReminderEntity> {
        return NSFetchRequest<ReminderEntity>(entityName: "ReminderEntity")
    }

    @NSManaged public var isRepeat: Int16
    @NSManaged public var title: String?
    @NSManaged public var notes: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?

}

extension ReminderEntity : Identifiable {

}
