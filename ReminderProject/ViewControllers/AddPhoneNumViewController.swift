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
//        phoneNumEntry.delegate = self
        view.backgroundColor = .red

        // Do any additional setup after loading the view.
    }
    
    @IBAction func hitContinueButton(_ sender: Any) {
        print(phoneNumEntry.text!)
        // Save phone number input by user
        defaults.set(phoneNumEntry.text!, forKey: "phoneNum")
//        defaults.set(true, forKey: "hasPhoneNum")
        
        // Transition to main reminders storyboard
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "remindersTableVC") as? ViewController else {
            print("failed to get vc")
            return
        }
        
        present(vc, animated: true)
//        present()
    }
    
    // Check if phone number exists user defaults
    func checkIfPhoneNum() {
        let phoneNum = defaults.bool(forKey: "hasPhoneNum")
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
