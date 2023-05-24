//
//  AddPhoneNumViewController.swift
//  ReminderProject
//
//  Created by Blumer, Seth on 5/23/23.
//

import UIKit

class AddPhoneNumViewController: UIViewController, UITextFieldDelegate {
    // To store phone number input by user
    @IBOutlet weak var phoneNumEntry: UITextField!
    
    // To fetch / add to user defaults, which in this case is just a phone number
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = "My Back Button Title"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        // Do any additional setup after loading the view.
    }
    
    @IBAction func hitContinueButton(_ sender: Any) {
        print(phoneNumEntry.text!)
        // Save phone number input by user
        defaults.set(phoneNumEntry.text!, forKey: "phoneNum")

        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
