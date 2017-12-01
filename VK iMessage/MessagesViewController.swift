//
//  MessagesViewController.swift
//  VK iMessage
//
//  Created by Eugene Khizhnyak on 01.12.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit
import Messages
import RealmSwift
import AlamofireImage

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriend()
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonTapHandler(sender: UIButton) {
        let layout = MSMessageTemplateLayout()
        layout.caption = textLabel.text
        layout.image = imageView.image
        let message = MSMessage()
        message.layout = layout
        activeConversation?.insert(message, completionHandler: nil)
    }
    
    // MARK: - Private
    
    private func loadFriend() {
        do {
            let realmInstance = try Realm(configuration: Storage.sharedInstance.realmConfig)
            let friends = realmInstance.objects(User.self)
            let friendsSet = NSSet(array: Array(friends));
            let placeholderImage = UIImage(named: "placeholder")!
            
            guard let user = friendsSet.anyObject() as? User else {
                textLabel.text = "нет друзей (("
                return
            }
            sendButton.isHidden = false;
            textLabel.text = user.userFirstName + " " + user.userLastName
            
            if let url = URL(string: user.userPhotoURL){
                imageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
        } catch {
            print("MessagesViewController realm error:\(error.localizedDescription)")
        }
    }
}
