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
        // Check user default for phone number here
        print("good morning")
        reminderTableView.delegate = self
        reminderTableView.dataSource = self
        reminderTableView.reloadData()
        // Test comment
        // Corey First commit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("good afternoon")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("good night")

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
    //TODO: Fix this top fit our project
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let popUpVC = AddEditReminderViewController()

//        let group = group[indexPath.row]
        
        let config = UIContextMenuConfiguration(identifier: indexPath as NSIndexPath) { () -> UIViewController? in
//            popUpVC.drawer = group
//            popUpVC.title = group.name
//            popUpVC.hidesBottomBarWhenPushed = true
            return popUpVC
        } actionProvider: { (actions) -> UIMenu? in
            let shareAction = UIAction(
                title: "Share",
                image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    // share the task
                }


            let deleteAction = UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                attributes: .destructive) { _ in
                    let alert = UIAlertController(title: "Are you sure you want to delete this drawer?",
                                                  message: "",
                                                  preferredStyle: .alert)
                    alert.view.tintColor = UIColor.label
                    alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
//                        self.group.remove(at: indexPath.row)
//                        self.tableView.reloadData()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel",
                                                  style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            
            return UIMenu(title: "", children: [shareAction, deleteAction])
        }
        return config
    }
}
