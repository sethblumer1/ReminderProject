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
import UserNotifications

class AddEditReminderViewController: UIViewController {
    
    var activeTextInput: UIView?
    var reminder: ReminderEntity?
    var repreatIndex = 0
    let date = Date()
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.tintColor = .systemCyan
        datePicker.backgroundColor = .secondarySystemBackground
        datePicker.layer.cornerRadius = 10
        datePicker.layer.masksToBounds = true // this allows you to change the corner radius
        return datePicker
    }()
    lazy var repeatLabel: UILabel = {
        let label = UILabel()
        label.text = "Repeat:"
        label.textColor = .label
        label.font = UIFont(name: "Helvetica Neue Medium", size: 18)
        return label
    }()
    lazy var repeatPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.layer.masksToBounds = true
        picker.layer.cornerRadius = 8.0
        picker.backgroundColor = .secondarySystemBackground
        return picker
    }()
    lazy var reminderName: UITextField = {
        let reminderName = UITextField()
        reminderName.placeholder = "Reminder Name"
        reminderName.layer.cornerRadius = 8.0
        reminderName.returnKeyType = .done
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
        notes.text = "Notes: "//.placeholder = "Notes:"
        notes.layer.cornerRadius = 8.0
        notes.returnKeyType = .done
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
        self.dismissKeyboard()
        notes.delegate = self
        reminderName.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.backgroundColor = .systemBackground
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        repeatPicker.delegate = self
        repeatPicker.dataSource = self
        repeatPicker.selectRow(repreatIndex, inComponent: 0, animated: false)
        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: view.height/10 + 60),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        reminderName.frame = CGRect(x: 20, y: view.height/10 + 5 /*datePicker.top - 70*/, width: view.width - 40, height: 45)
        notes.frame = CGRect(x: 20, y: datePicker.bottom + 10, width: view.width - 40, height: view.height/1.25 - (reminderName.height + repeatPicker.height + datePicker.height + saveButton.height - 15))
//        notes.frame = CGRect(x: 20, y: datePicker.bottom + 10, width: view.width - 40, height: view.height/13)
        repeatPicker.frame = CGRect(x: 120, y: notes.bottom + 10, width: view.width - 140, height: view.height/15)
        repeatLabel.frame = CGRect(x: 30, y: notes.bottom + 10, width: view.width - repeatPicker.width, height: view.height/15)
        saveButton.frame = CGRect(x: view.width/2 - 60 , y: repeatPicker.bottom + 10, width: 120, height: 40)
//        saveButton.frame = CGRect(x: view.width/2 - 60 , y: view.bottom - 60, width: 120, height: 40)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("ReloadTable"), object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    @objc func saveTapped() {
        print("save tapped")
        print("selected reminder \(repeatPicker.selectedRow(inComponent: 0))")
        repreatIndex = (repeatPicker.selectedRow(inComponent: 0))
        print(datePicker.date)
        print(reminderName.text!)
        print(notes.text!)
        if reminderName.text != "" {
            if reminder == nil {
                if datePicker.date > date {
                    CoreDataHelper.shareInstance.createReminder(date: datePicker.date, title: reminderName.text!, notes: notes.text!, isRepeat: Int16(repreatIndex))
//                    scheduleLocalNotification(at: datePicker.date.timeIntervalSince1970, reminderID: <#T##UUID#>, withTitle: <#T##String#>, andBody: <#T##String#>, repeatInterval: repreatIndex)
                    self.dismiss(animated: true)
                } else {
                    // throw alert
                    let alert = UIAlertController(title: "Date error",
                                                  message: "Reminder date is before current date",
                                                  preferredStyle: .alert)
                    alert.view.tintColor = UIColor.label
                    alert.addAction(UIAlertAction(title: "Cancel",
                                                  style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }

            } else {
                CoreDataHelper.shareInstance.updateReminder(withId: (reminder?.id)!, newDate: datePicker.date, newTitle: reminderName.text!, newNotes: notes.text!, updatedRepeat: Int16(repreatIndex))
//                scheduleLocalNotification(at: datePicker.date.timeIntervalSince1970, reminderID: <#T##UUID#>, withTitle: <#T##String#>, andBody: <#T##String#>, repeatInterval: <#T##Int#>)
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
                                                                        // throw alert
            let alert = UIAlertController(title: "Can't Save Reminder",
                                          message: "Please provide a name for reminder",
                                          preferredStyle: .alert)
            alert.view.tintColor = UIColor.label
            alert.addAction(UIAlertAction(title: "Cancel",
                                          style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        //        TODO: throw an error if the assigned date is >= today's time and date

    }
    
    func addSubviews() {
        view.addSubview(datePicker)
        view.addSubview(reminderName)
        view.addSubview(notes)
        view.addSubview(saveButton)
        view.addSubview(repeatPicker)
        view.addSubview(repeatLabel)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let intersection = view.frame.intersection(keyboardFrame)
            let keyboardHeight = intersection.height
            
            if let activeTextInput = activeTextInput {
                let maxY = activeTextInput.frame.maxY
                let distanceToMove = maxY - (view.frame.height - keyboardHeight)
                if distanceToMove > 0 {
                    if let userInfo = notification.userInfo,
                       let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

                        let intersection = view.frame.intersection(keyboardFrame)
                        view.frame.origin.y = -intersection.height
                    }
                }
            }
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
        }
                                               
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // If the return key (or enter key) is pressed, hide the keyboard
            notes.resignFirstResponder()
            reminderName.resignFirstResponder()
            return false // Return false to prevent adding a newline character to the text view
        }
        return true

    }
}
extension AddEditReminderViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextInput = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextInput = nil
    }
}
extension AddEditReminderViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextInput = textView
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextInput = nil
    }
}
extension AddEditReminderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "none"
        case 1:
            return "daily"
        case 2:
            return "weekdays"
        case 3:
            return "weekly"
        case 4:
            return "bi-weekly"
        case 5:
            return "monthly"
        case 6:
            return "yearly"
        default:
            return "none"
        }
        /*
         daily
         weekdays
         weekly
         bi-weekly
         monthly
         yearly
         */
    }
}


extension UIViewController {
        func dismissKeyboard() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:   self,
                                                                      action: #selector(UIViewController.dismissKeyboardTouchOutside))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        @objc private func dismissKeyboardTouchOutside() {
            view.endEditing(true)
        }
    }
