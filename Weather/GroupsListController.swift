//
//  TableViewController2.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 19.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class GroupsListController: UITableViewController {
    
    var selectedGroups = [NewGroupData]()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedGroups.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! GroupTableViewCell
        let groupData = selectedGroups[indexPath.row]
        cell.groupNameLabel.text = groupData.groupName
        cell.groupImageView.image = UIImage(named: groupData.avatarName)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            selectedGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    @IBAction func closeNewGroupsListControllerTapHandler(unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func selectAndCloseNewGroupsListControllerTapHandler(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "didSelectGroup" {
            let groupsController = unwindSegue.source as! NewGroupsController
            
            if let indexPath = groupsController.tableView.indexPathForSelectedRow {
                let group = groupsController.groups[indexPath.row]
                
                if !selectedGroups.contains(group) {
                    selectedGroups.append(group)
                    tableView.reloadData()
                }
            }
        }
    }
}
