//
//  TableViewController1.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 19.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class FriendsListController: UITableViewController {
    
    let itemsDictionary = ["avatar1" : "John Smith", "avatar2" : "Victoria Graham", "avatar3" : "Matt Busby"]
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsDictionary.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! FriendTableViewCell
        let keys = Array(itemsDictionary.keys)
        let key = keys[indexPath.row]
        cell.nameLabel.text = itemsDictionary[key]
        cell.avatarImageView.image = UIImage(named:key)
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
                let keys = Array(itemsDictionary.keys)
                let key = keys[selectedIndexPath.row]
                friendAvatarController.selectedAvatarName = key
                friendAvatarController.selectedName = itemsDictionary[key]!
            }
        }
    }
    
    @IBAction func closeCurrentControllerTapHandler(unwindSegue: UIStoryboardSegue) {
    }
}
