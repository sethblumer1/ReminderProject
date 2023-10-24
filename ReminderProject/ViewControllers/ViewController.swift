//
//  ViewController.swift
//  ReminderProject
//
//  Created by Blumer, Seth on 5/2/23.
//

import Foundation
import UIKit
import SwiftUI

class ViewController: UIViewController {

    @IBOutlet weak var reminderTableView: UITableView!
    
    var reminders: [ReminderEntity] = []
    var hostedReminders: [Reminder] = []
    let date = Date()
    let defaults = UserDefaults.standard
    
    struct Reminder: Codable {
        let date: String
        let hoursOffset: String
        let notes: String
        let isRepeat: String
        let id: String
        let phoneNum: String
        let title: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Check user default for phone number here
//        defaults.removeObject(forKey: "phoneNum")
        //    TODO: uncomment below
        let localData = defaults.string(forKey: "versionType")
        print("local data: \(localData)")
        checkPhoneNumber()
        getReminders()
//        print(hostedReminders)
        reminderTableView.delegate = self
        reminderTableView.dataSource = self
        reminderTableView.reloadData()
//        print(defaults.string(forKey: "versionType")!)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: NSNotification.Name("ReloadTable"), object: nil)
    }
    override func viewWillAppear (_ animated: Bool) {
        super.viewWillAppear(animated)
        getReminders()
        reminderTableView.reloadData()
    }
    @objc func reloadTable() {
        getReminders()
//        print("closed page")
        reminderTableView.reloadData()
    }
    
    func getReminders() {
        reminders = CoreDataHelper.shareInstance.fetchReminders()
        
//        let versionType = defaults.string(forKey: "versionType")!
//
//        if (versionType == "Local") {
//            reminders = CoreDataHelper.shareInstance.fetchReminders()
//        } else {
//            getRemindersHosted(urlString: "https://3s5hv467o8.execute-api.us-east-1.amazonaws.com/reminders") { result in
//                switch result {
//                case .success(let data):
//                    do {
//                        let decoder = JSONDecoder()
//                        let fetchedReminders = try decoder.decode([Reminder].self, from: data)
//                        self.hostedReminders = fetchedReminders
//                    } catch {
//                        print("Error decoding JSON: \(error)")
//                    }
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            }
//        }
        
    }
    
    func getStringFromDate(reminderDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: reminderDate)
    }
    
    func getDateFromString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.date(from: dateString)!
    }
    
    func checkPhoneNumber() {
        let phoneNumber = defaults.string(forKey: "phoneNum")
        
        if phoneNumber == nil
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "addPhoneNum")
            self.navigationController?.pushViewController(vc, animated: true)

        } else {
            print(phoneNumber!) //ignore
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! RemindersTableViewCell

        if defaults.string(forKey: "versionType") != nil {
            let versionType = defaults.string(forKey: "versionType")!
        }

        print(hostedReminders)
        
        let reminder = reminders[indexPath.row]
        cell.reminderLabel.text = reminder.title
        cell.expirationLabel.text = getStringFromDate(reminderDate: reminder.date!)
        if reminders[indexPath.row].date! > date {
            cell.expirationLabel.textColor = .label
        } else {
            cell.expirationLabel.textColor = .red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reminder = reminders[indexPath.row]
        
        let editVC = AddEditReminderViewController()
        editVC.datePicker.date = reminder.date!
        editVC.reminderName.text = reminder.title
        editVC.notes.text = reminder.notes!
        editVC.reminder = reminder
        editVC.repreatIndex = Int(reminder.isRepeat)
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    //TODO: Fix this top fit our project
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let popUpVC = AddEditReminderViewController()

        let reminder = reminders[indexPath.row]
        
        let config = UIContextMenuConfiguration(identifier: indexPath as NSIndexPath) { () -> UIViewController? in
            popUpVC.datePicker.date = reminder.date!
            popUpVC.reminderName.text = reminder.title
            popUpVC.notes.text = reminder.notes!
            return popUpVC
        } actionProvider: { (actions) -> UIMenu? in
//            let shareAction = UIAction(
//                title: "Share",
//                image: UIImage(systemName: "square.and.arrow.up")) { _ in
//                    // share the task
//                }

            let deleteAction = UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                attributes: .destructive) { _ in
                    let alert = UIAlertController(title: "Are you sure you want to delete this reminder?",
                                                  message: "",
                                                  preferredStyle: .alert)
                    alert.view.tintColor = UIColor.label
                    alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                        let reminders = self.reminders[indexPath.row]
                        CoreDataHelper.shareInstance.deleteReminder(reminder: reminders)
                        self.reminders.remove(at: indexPath.row)
                        self.reminderTableView.reloadData()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel",
                                                  style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            
            return UIMenu(title: "", children: [deleteAction])
        }
        return config
    }
}
