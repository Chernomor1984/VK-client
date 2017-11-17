//
//  AddPostController.swift
//  VK
//
//  Created by Eugene Khizhnyak on 17.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit
import Foundation

class AddPostController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
}
