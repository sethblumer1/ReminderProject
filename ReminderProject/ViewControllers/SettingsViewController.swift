//
//  SettingsViewController.swift
//  ReminderProject
//
//  Created by Green, Corey on 5/9/23.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var versionSegementedControl: UISegmentedControl!
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        if defaults.string(forKey: "versionType") == "Local"
        {
            versionSegementedControl.selectedSegmentIndex = 0
        } else {
            versionSegementedControl.selectedSegmentIndex = 1
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func changeVersionType(_ sender: Any) {
        var versionType = defaults.string(forKey: "versionType")

        if versionSegementedControl.selectedSegmentIndex == 0 {
            versionType = "Local"
            CoreDataHelper.shareInstance.convertData(to: "Local")
        } else {
            versionType = "Hosted"
            CoreDataHelper.shareInstance.convertData(to: "Hosted")
        }
        defaults.set(versionType, forKey: "versionType")
        let localData = defaults.string(forKey: "versionType")
        print("local data: \(localData!)")
        
    }
// MARK: Settings needed:
    /*
     set/change phone number
     wipe all reminders
     switch from hosted to 
     notification preferences
     */

}
