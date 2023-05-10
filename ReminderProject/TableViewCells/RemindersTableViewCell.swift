//
//  RemindersTableViewCell.swift
//  ReminderProject
//
//  Created by Green, Corey on 5/9/23.
//

import UIKit

class RemindersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.setCellShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
