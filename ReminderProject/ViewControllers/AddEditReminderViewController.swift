//
//  AddEditReminderViewController.swift
//  ReminderProject
//
//  Created by Green, Corey on 5/9/23.
//

import UIKit

class AddEditReminderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.tintColor = .systemCyan
        datePicker.backgroundColor = .secondarySystemBackground
//        datePicker.layer.cornerRadius = 10
        return datePicker
    }()
    lazy var reminderName: UITextField = {
        let reminderName = UITextField()
        return reminderName
    }()
    
    override func viewDidLayoutSubviews() {
        datePicker.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: view.frame.height/2)
    }
    func addSubviews() {
        view.addSubview(datePicker)
    }
}
