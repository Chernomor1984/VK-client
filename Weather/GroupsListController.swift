//
//  TableViewController2.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 19.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlamofireImage

class GroupsListController: UITableViewController {
    
    var groups = [Group]()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGroups()
    }
    
    // MARK: - Private
    
    private func loadGroups() {
        let userID = HTTPSessionManager.sharedInstance.userID
        
        if let userID = Int(userID){
            weak var weakSelf = self
            HTTPSessionManager.sharedInstance.performGroupsListRequest(userID: userID) { (data, urlResponse, error) in
                guard let data = data else {
                    return
                }
                
                let json = JSON(data: data)
                let array = json["response"].flatMap({Group(json: $0.1)})
                weakSelf?.groups = array.filter{$0.imageURL != nil}
                DispatchQueue.main.async {
                    weakSelf?.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! GroupTableViewCell
        let group = groups[indexPath.row]
        cell.groupNameLabel.text = group.name
        let placeholderImage = UIImage(named: "placeholder")!
        cell.groupImageView.af_setImage(withURL: group.imageURL, placeholderImage: placeholderImage)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            groups.remove(at: indexPath.row)
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
                let group = groupsController.filteredGroups[indexPath.row]
                
                if !groups.contains(group) {
                    groups.append(group)
                    tableView.reloadData()
                }
            }
        }
    }
}
