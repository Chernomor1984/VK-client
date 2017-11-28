//
//  TodayViewController.swift
//  VK extension
//
//  Created by Eugene Khizhnyak on 28.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    private var downloadQueue = OperationQueue()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriendsRequests()
    }
    
    // MARK: - Private
    
    private func loadFriendsRequests() {
        let friendsRequestsOperation = LoadFriendsRequestsIDOperation()
        let loadNewFriendsOperation = LoadNewFriendsOperation()
        loadNewFriendsOperation.completionBlock = {
            DispatchQueue.main.async {
                self.nameLabel.text = loadNewFriendsOperation.userName
                self.locationLabel.text = loadNewFriendsOperation.userLocation
            }
        }
        loadNewFriendsOperation.addDependency(friendsRequestsOperation)
        downloadQueue.addOperation(friendsRequestsOperation)
        downloadQueue.addOperation(loadNewFriendsOperation)
    }
    
    // MARK: - Actions
    
    @IBAction func moreButtonTapHandler(sender: UIButton) {
        if let url =  URL(string: "vkClient://") {
            extensionContext?.open(url)
        }
    }
}
