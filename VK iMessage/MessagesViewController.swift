//
//  MessagesViewController.swift
//  VK iMessage
//
//  Created by Eugene Khizhnyak on 01.12.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonTapHandler(sender: UIButton) {
        let layout = MSMessageTemplateLayout()
        layout.caption = "какой-то текст"
        layout.image = UIImage(named: "placeholder")
        let message = MSMessage()
        message.layout = layout
        activeConversation?.insert(message, completionHandler: nil)
    }
}
