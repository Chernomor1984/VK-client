//
//  NewFriendsRequestsController.swift
//  VK
//
//  Created by Eugene Khizhnyak on 28.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import AlamofireImage

class NewFriendsRequestsController: UITableViewController {
    private var friendRequests: [NewFriend] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriendsRequests()
    }
    
    // MARK: - Private
    
    private func loadFriendsRequests() {
        guard let userIDs = readFriendsIDs() else {
            return
        }
        
        HTTPSessionManager.sharedInstance.performNewFriendsRequest(userIDs: userIDs) { [weak self] (data, response, error) in
            if let error = error {
                print("NewFriendsRequestsController performNewFriendsRequest failed: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let json = try? JSON(data: data) else {
                return
            }
            
            self?.friendRequests = json["response"].flatMap{NewFriend(json: $0.1)}
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = 0
                self?.tableView.reloadData()
            }
        }
    }
    
    private func readFriendsIDs() -> String? {
        guard let data = UserDefaults.standard.object(forKey: newFriendsIdsKey) as? Data, let json = try? JSON(data: data) else {
            return nil
        }
        UserDefaults.standard.removeObject(forKey: newFriendsIdsKey)
        guard let friendsIDs = json["response"]["items"].arrayObject as? [Int] else {
            return nil
        }
        let userIDs = friendsIDs.map{String($0)}.joined(separator: ",")
        return String(userIDs)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendRequests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! NewFriendRequestCell
        let friend = self.friendRequests[indexPath.row]
        cell.nameLabel.text = friend.name
        cell.locationLabel.text = friend.city
        
        if let url = friend.imageURL {
            let placeholderImage = UIImage(named: "placeholder")!
            cell.avatarImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
        return cell
    }
}
