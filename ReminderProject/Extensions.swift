//
//  Extensions.swift
//  ReminderProject
//
//  Created by Green, Corey on 5/10/23.
//

import Foundation
import UIKit
import SwiftUI

extension UIView {
    // For laying out views with code

    public var width: CGFloat { return frame.size.width }
    public var height: CGFloat { return frame.size.height }
    public var top: CGFloat { return frame.origin.y }
    public var bottom: CGFloat { return frame.origin.y + frame.size.height }
    public var left: CGFloat { return frame.origin.x }
    public var right: CGFloat { return frame.origin.x + frame.size.width }
    
    func setCellShadow() {
        self.layer.cornerRadius = 15
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1.2
        self.layer.shadowOpacity = 0.55
    }
    
}
