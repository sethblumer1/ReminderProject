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
    var phoneNum = ""
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = "My Back Button Title"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        //        phoneNumEntry.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func hitContinueButton(_ sender: Any) {
        print(phoneNumEntry.text!)
        // Save phone number input by user
        defaults.set(phoneNumEntry.text!, forKey: "phoneNum")

        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
