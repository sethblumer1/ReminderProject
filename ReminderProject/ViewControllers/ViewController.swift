//
//  ViewController.swift
//  ReminderProject
//
//  Created by Blumer, Seth on 5/2/23.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    

    @IBOutlet weak var reminderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("good morning")
        reminderTableView.delegate = self
        reminderTableView.dataSource = self
        reminderTableView.reloadData()
        // Test comment
        // Corey First commit
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! RemindersTableViewCell
        cell.reminderLabel.text = "ReMinDeR label!!!"
        cell.expirationLabel.text = "1/1/23 4:45 PM"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        let editVC = AddEditReminderViewController()
        navigationController?.pushViewController(editVC, animated: true)
    }
}
