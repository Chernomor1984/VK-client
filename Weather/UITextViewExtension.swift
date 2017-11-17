//
//  UITextViewExtension.swift
//  VK
//
//  Created by Eugene Khizhnyak on 17.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func addBorder(colour borderColour: UIColor = UIColor.black, width borderWidth: Float = 1.0, radius cornerRadius: Float = 5.0) {
        self.layer.borderColor = borderColour.cgColor
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.cornerRadius = CGFloat(cornerRadius)
    }
}
