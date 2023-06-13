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
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Check user default for phone number here
        defaults.removeObject(forKey: "phoneNum")
//    TODO: uncomment below
//        checkPhoneNumber()
        print("good morning")
        getReminders()
        reminderTableView.delegate = self
        reminderTableView.dataSource = self
        reminderTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: NSNotification.Name("ReloadTable"), object: nil)
        // Test comment
        // Corey First commit
    }
    @objc func reloadTable() {
        getReminders()
        self.reminderTableView.reloadData()
    }
    func getReminders() {
        reminders = CoreDataHelper.shareInstance.fetchReminders()
    }
    func getStringFromDate(reminderDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: reminderDate)
    }
    func checkPhoneNumber() {
        let phoneNumber = defaults.string(forKey: "phoneNum")
        
        if phoneNumber == nil
        {
            //pushAddNumberPage]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "addPhoneNum")
            self.navigationController?.pushViewController(vc, animated: true)

        } else {
            print(phoneNumber) //ignore
        }
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! RemindersTableViewCell

        let reminder = reminders[indexPath.row]
        cell.reminderLabel.text = reminder.title
        cell.expirationLabel.text = getStringFromDate(reminderDate: reminder.date!)
        //"1/1/23 4:45 PM"// reminder.date.da
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        
        let reminder = reminders[indexPath.row]
        
        let editVC = AddEditReminderViewController()
        editVC.datePicker.date = reminder.date!
        editVC.reminderName.text = reminder.title
        editVC.notes.text = reminder.notes!
        editVC.reminder = reminder
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
            let shareAction = UIAction(
                title: "Share",
                image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    // share the task
                }

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
            
            return UIMenu(title: "", children: [shareAction, deleteAction])
        }
        return config
    }
}
