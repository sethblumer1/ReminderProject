//
//  Extensions.swift
//  ReminderProject
//
//  Created by Green, Corey on 5/10/23.
//

import Foundation
import UIKit
import SwiftUI
import UserNotifications

extension UIView {
    // For laying out views with code

    public var width: CGFloat { return frame.size.width }
    public var height: CGFloat { return frame.size.height }
    public var top: CGFloat { return frame.origin.y }
    public var bottom: CGFloat { return frame.origin.y + frame.size.height }
    public var left: CGFloat { return frame.origin.x }
    public var right: CGFloat { return frame.origin.x + frame.size.width }
    
    func setCellShadow() {
        self.layer.cornerRadius = 15
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1.2
        self.layer.shadowOpacity = 0.55
    }
    
}
//extension UIViewController  {
//    func scheduleLocalNotification(at timestamp: TimeInterval, reminderID: UUID, withTitle title: String, andBody body: String, repeatInterval: Int) {
//        let center = UNUserNotificationCenter.current()
//
//        // Request permission to display notifications (if not already granted)
//        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
//            if granted {
//                // Create a notification content
//                let content = UNMutableNotificationContent()
//                content.title = title
//                content.body = body
//                content.sound = UNNotificationSound.default
//
//                // Create a date component based on the provided timestamp
//                let date = Date(timeIntervalSince1970: timestamp)
//                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//
//                var trigger: UNNotificationTrigger
//
//                switch repeatInterval {
//                case 0:
//                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//                case 1:
//                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//                case 2:
//                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 604800, repeats: true)
//                case 3:
//                    var weeklyComponents = DateComponents()
//                    weeklyComponents.hour = dateComponents.hour
//                    weeklyComponents.minute = dateComponents.minute
//                    trigger = UNCalendarNotificationTrigger(dateMatching: weeklyComponents, repeats: true)
//                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)
//                case 4:
//                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1209600, repeats: true)
//                case 5:
//                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2592000, repeats: true)
//                case 6:
//                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 31536000, repeats: true)
//                default:
//                    trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//                }
//
//                // Create a notification request
//                let uuidString = reminderID.uuidString //UUID().uuidString
//                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
//
//                // Schedule the notification
//                center.add(request) { (error) in
//                    if let error = error {
//                        print("Error scheduling notification: \(error)")
//                    } else {
//                        print("Notification scheduled successfully!")
//                    }
//                }
//            } else {
//                print("Notification permission not granted.")
//            }
//        }
//    }
//}
