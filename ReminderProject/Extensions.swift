//
//  Extensions.swift
//  ReminderProject
//
//  Created by Green, Corey on 5/10/23.
//

import Foundation
import UIKit

extension UIView {
    
    func setCellShadow() {
        self.layer.cornerRadius = 15
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1.2
        self.layer.shadowOpacity = 0.55
    }
    
}
