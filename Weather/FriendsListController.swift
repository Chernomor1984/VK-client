//
//  TableViewController1.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 19.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit
import AlamofireImage

class FriendsListController: UITableViewController {
    var friends = [User]()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriendsFromCache()
        loadFriendsList()
    }
    
    // MARK: - Private
    
    private func loadFriendsFromCache() {
        weak var weakSelf = self
        let completionHandler = { (users: [User]?, error: Error?) -> Void in
            if let error = error {
                print("loadFriendsFromCache error: \(error.localizedDescription)")
                return
            }
            weakSelf?.friends = users!
            DispatchQueue.main.async {
                weakSelf?.tableView.reloadData()
            }
        }
        Storage.sharedInstance.loadFriendsFromCache(completionHandler: completionHandler)
    }
    
    private func loadFriendsList() {
        weak var weakSelf = self
        HTTPSessionManager.sharedInstance.performFriendsListRequest { error in
            if let error = error {
                print("loadFriendsFromCache error: \(error.localizedDescription)")
                return
            }
            weakSelf?.loadFriendsFromCache()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! FriendTableViewCell
        let user = friends[indexPath.row]
        cell.item.userID = String(describing: user.userID)
        cell.nameLabel.text = user.userFirstName + " " + user.userLastName
        let placeholderImage = UIImage(named: "placeholder")!
        
        if let url = URL(string: user.userPhotoURL){
            cell.avatarImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "didSelectFriend"{
            let navigationController = segue.destination as! UINavigationController
            let friendAvatarController = navigationController.viewControllers[0] as! FriendAvatarController
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let user = friends[selectedIndexPath.row]
                
                if let userID = Int(user.userID){
                    friendAvatarController.userID = userID
                }
                friendAvatarController.selectedName = user.userFirstName + " " + user.userLastName
            }
        }
    }
    
    @IBAction func closeCurrentControllerTapHandler(unwindSegue: UIStoryboardSegue) {
    }
}
