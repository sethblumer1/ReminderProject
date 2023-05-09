//
//  ViewController.swift
//  ReminderProject
//
//  Created by Blumer, Seth on 5/2/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! RemindersTableViewCell
        cell.reminderLabel.text = "ReMinDeR label!!!"
        cell.expirationLabel.text = "1/1/23 4:45 PM"
        return cell
    }
    

    @IBOutlet weak var reminderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderTableView.delegate = self
        reminderTableView.dataSource = self
        // Test comment
        // Corey First commit
    }


}

