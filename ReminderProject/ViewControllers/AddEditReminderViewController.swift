//
//  AddEditReminderViewController.swift
//  ReminderProject
//
//  Created by Green, Corey on 5/9/23.
//

import Foundation
import UIKit
import SwiftUI

class AddEditReminderViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        view.backgroundColor = .systemBackground
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
        notes.frame = CGRect(x: 20, y: datePicker.bottom + 25, width: view.width - 40, height: 120)
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("see you")
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("later")
    }
    func addSubviews() {
        view.addSubview(datePicker)
        view.addSubview(reminderName)
        view.addSubview(notes)
    }
}
