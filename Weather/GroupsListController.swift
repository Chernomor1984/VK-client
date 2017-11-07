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
import RealmSwift

class GroupsListController: UITableViewController {
    var groups: Results<Group>!
    var token: NotificationToken?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGroupsFromCache()
        loadGroups()
    }
    
    // MARK: - Private
    
    private func loadGroupsFromCache() {
        weak var weakSelf = self
        let completionHandler = { (groups: Results<Group>?, error: Error?) -> Void in
            if let error = error {
                print("loadGroupsFromCache error: \(error.localizedDescription)")
                return
            }
            weakSelf?.groups = groups
            weakSelf?.token = weakSelf?.groups.observe({[weak self] (changes: RealmCollectionChange) in
                switch changes {
                case .initial:
                    self?.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self?.tableView.beginUpdates()
                    self?.tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}),
                                               with: .automatic)
                    self?.tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}),
                                               with: .automatic)
                    self?.tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}),
                                               with: .automatic)
                    self?.tableView.endUpdates()
                case .error(let error):
                    print("error:\(error)")
                }
            })
        }
        Storage.sharedInstance.loadGroupsFromCache(completionHandler: completionHandler)
    }
    
    private func loadGroups() {
        guard let userID = UserDefaults.standard.string(forKey: userIDKey) else {
            return
        }
        
        if let userID = Int(userID){
            HTTPSessionManager.sharedInstance.performGroupsListRequest(userID: userID, completionHandler: { error in
                if let error = error {
                    print("loadGroups error: \(error.localizedDescription)")
                    return
                }
            })
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! GroupTableViewCell
        let group = groups[indexPath.row]
        cell.groupNameLabel.text = group.name
        let placeholderImage = UIImage(named: "placeholder")!
        
        if let url = URL(string: group.imageURL){
            cell.groupImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let objectToDelete = groups[indexPath.row]
            Storage.sharedInstance.removeObject(objectToDelete)
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
                    Storage.sharedInstance.addObject(group)
                }
            }
        }
    }
}
