//
//  TableViewController1.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 19.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class FriendsListController: UITableViewController {
    
    var friends = [[String:AnyObject]]()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriendsList()
    }
    
    // MARK: - Private
    
    private func loadFriendsList() {
        HTTPSessionManager.sharedInstance.performFriendsListRequest { (data, response, error) in
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) else {
                return
            }
            
            let dictionary = json as! [String: Any]
            weak var weakSelf = self
            weakSelf?.friends = dictionary["response"] as! [[String:AnyObject]]
            DispatchQueue.main.async {
                weakSelf?.tableView.reloadData()
            }
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
        let dict = friends[indexPath.row]
        cell.item.userID = String(describing: dict["user_id"])
        cell.item.userPhotoURL = URL(fileURLWithPath: dict["photo_50"] as! String)
        
        if let lastName = dict["last_name"], let firstName = dict["first_name"] {
            cell.nameLabel.text = (lastName as! String) + " " + (firstName as! String)
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
                let dict = friends[selectedIndexPath.row]
                
                if let userID = dict["user_id"] {
                    friendAvatarController.userID = userID as! Int
                }
                
                if let lastName = dict["last_name"], let firstName = dict["first_name"] {
                    friendAvatarController.selectedName = (lastName as! String) + " " + (firstName as! String)
                }
            }
        }
    }
    
    @IBAction func closeCurrentControllerTapHandler(unwindSegue: UIStoryboardSegue) {
    }
}
