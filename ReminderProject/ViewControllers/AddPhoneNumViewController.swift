//
//  AddPhoneNumViewController.swift
//  ReminderProject
//
//  Created by Blumer, Seth on 5/23/23.
//

import UIKit
import SwiftUI

class AddPhoneNumViewController: UIViewController, UITextFieldDelegate {
    // To store phone number input by user
    @IBOutlet weak var phoneNumEntry: UITextField!
    @IBOutlet weak var versionSegementedControl: UISegmentedControl!
    var versionType = "Local"
    
    // To fetch / add to user defaults, which in this case is just a phone number
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = "My Back Button Title"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeVersionType(_ sender: Any) {
        if versionSegementedControl.selectedSegmentIndex == 0 {
            versionType = "Local"
        } else {
            versionType = "Hosted"
        }
    }
    
    @IBAction func hitContinueButton(_ sender: Any) {
        print("Version type: \(versionType)")
        print(phoneNumEntry.text!)
        // Save phone number input by user
        defaults.set(phoneNumEntry.text!, forKey: "phoneNum")
        defaults.set(versionType, forKey: "versionType")
        
//        defaults.set(versionType)

        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
