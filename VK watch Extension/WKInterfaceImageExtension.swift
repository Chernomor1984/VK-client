//
//  WKInterfaceImageExtension.swift
//  VK watch Extension
//
//  Created by Eugene Khizhnyak on 05.12.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import WatchKit

extension WKInterfaceImage {
    func showActivityIndicator() {
        self.setHidden(false)
        self.setImageNamed("Activity")
        self.startAnimatingWithImages(in: NSMakeRange(0, 30), duration: 1.0, repeatCount: 0)
    }
    
    func hideActivityIndicator() {
        self.setHidden(true)
        self.stopAnimating()
    }
}
