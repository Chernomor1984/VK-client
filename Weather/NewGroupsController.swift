//
//  NewGroupsTableViewController.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 22.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class NewGroupsController: UITableViewController {
    var groups = [AnyObject]()
    var filteredGroups = [AnyObject]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredGroups.count : groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! NewGroupTableViewCell
        let group = isFiltering() ? filteredGroups[indexPath.row] : groups[indexPath.row]
//        cell.groupNameLabel.text =
//        cell.membersCountLabel.text = String(group.membersCount)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Public
    
    func selectedGroup(row: Int) -> AnyObject {
        return isFiltering() ? filteredGroups[row] : groups[row]
    }
    
    // MARK: - Private
    
//    private func createNewGroups() {
//        for i in 0..<names.count {
//            let groupData = NewGroupData(names[i], avatarName: avatars[i], membersCount: members[i])
//            groups.append(groupData)
//        }
//    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext  = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    fileprivate func filterGroupsForText(_ searchText: String, scope: String = "All") {
//        let filterClosure = {(group: NewGroupData) -> Bool in
//            return group.groupName.lowercased().contains(searchText.lowercased())
//        }
//        filteredGroups = groups.filter(filterClosure)
//        tableView.reloadData()
        if searchText.count < 2 {
            return
        }
        HTTPSessionManager.sharedInstance.performGroupsSearchRequest(text: searchText) { (data, urlResponse, error) in
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) else {
                return
            }
            let dictionary = json as! [String: Any]
            print(dictionary)
            let groupsArray = dictionary["response"] as! [AnyObject]
            print(groupsArray)
        }
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension NewGroupsController: UISearchResultsUpdating {
    
    // MARK: - UISearchResultsUpdating Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        filterGroupsForText(searchController.searchBar.text!)
    }
}
