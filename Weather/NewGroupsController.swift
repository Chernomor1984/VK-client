//
//  NewGroupsTableViewController.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 22.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class NewGroupsController: UITableViewController {
    let names = ["Group1", "Group2", "Group3", "Group4", "Group5"]
    let avatars = ["group1", "group2", "group3", "group4", "group5"]
    let members = [123, 15, 64, 28, 97]
    var groups = [NewGroupData]()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.createNewGroups()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! NewGroupTableViewCell
        cell.groupNameLabel.text = groups[indexPath.row].groupName
        cell.groupImageView.image = UIImage(named: groups[indexPath.row].avatarName)
        cell.membersCountLabel.text = String(groups[indexPath.row].membersCount)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private
    
    private func createNewGroups() {
        for i in 0..<names.count {
            let groupData = NewGroupData(names[i], avatarName: avatars[i], membersCount: members[i])
            groups.append(groupData)
        }
    }
}
