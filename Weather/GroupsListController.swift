//
//  TableViewController2.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 19.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class GroupsListController: UITableViewController {
    
    let itemsDictionary = ["group1" : "Клуб любителей гольфа", "group2" : "Группа крутых чуваков", "group3" : "Группа любителей пива"]
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! GroupTableViewCell
        let keys = Array(itemsDictionary.keys)
        let key = keys[indexPath.row]
        cell.groupNameLabel.text = itemsDictionary[key]
        cell.groupImageView.image = UIImage(named:key)
        return cell
    }
}
