//
//  AddEditReminderViewController.swift
//  ReminderProject
//
//  Created by Green, Corey on 5/9/23.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

class AddEditReminderViewController: UIViewController {
    
    var reminder: ReminderEntity?
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.tintColor = .systemCyan
        datePicker.backgroundColor = .secondarySystemBackground
        datePicker.layer.cornerRadius = 10
        datePicker.layer.masksToBounds = true // this allows you to change the corner radius
        return datePicker
    }()
    lazy var reminderName: UITextField = {
        let reminderName = UITextField()
        reminderName.placeholder = "Reminder Name"
        reminderName.layer.cornerRadius = 8.0
        reminderName.backgroundColor = .secondarySystemBackground
        reminderName.layer.masksToBounds = true
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: reminderName.frame.height)) // left padding to the textfield
        reminderName.leftView = leftView
        reminderName.leftViewMode = .always
        return reminderName
    }()
    lazy var notes: UITextView = {
        let notes = UITextView()
        notes.layer.masksToBounds = true
        notes.layer.cornerRadius = 8.0
        notes.backgroundColor = .secondarySystemBackground
        return notes
    }()
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8.0
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemCyan
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        view.backgroundColor = .systemBackground
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
//        let saveButton = UIBarButtonItem()
//        saveButton.title = "Save"
//        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = saveButton
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        reminderName.frame = CGRect(x: 20, y:  datePicker.top - 70, width: view.width - 40, height: 45)
        notes.frame = CGRect(x: 20, y: datePicker.bottom + 15, width: view.width - 40, height: 75)
        saveButton.frame = CGRect(x: view.width/2 - 60 , y: notes.bottom + 15, width: 120, height: 40)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("ReloadTable"), object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        NotificationCenter.default.post(name: NSNotification.Name("ReloadTable"), object: nil)
    }
    @objc func saveTapped() {
        print("save tapped")
        print(datePicker.date)
        print(reminderName.text!)
        print(notes.text!)
        if reminderName.text != "" {
            if reminder == nil {
                CoreDataHelper.shareInstance.createReminder(date: datePicker.date, title: reminderName.text!, notes: notes.text!, isRepeat: -1)
                self.dismiss(animated: true)
            } else {
                CoreDataHelper.shareInstance.updateReminder(withId: (reminder?.id)!, newDate: datePicker.date, newTitle: reminderName.text!, newNotes: notes.text!, updatedRepeat: -1)
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
//            throw alert
//        TODO: setup alert to remind user to give reminder a name
        }

    }
    func addSubviews() {
        view.addSubview(datePicker)
        view.addSubview(reminderName)
        view.addSubview(notes)
        view.addSubview(saveButton)
    }
}
