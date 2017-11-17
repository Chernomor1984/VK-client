//
//  NewGroupsTableViewController.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 22.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewGroupsController: UITableViewController {
    var filteredGroups = [Group]()
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
        return filteredGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! NewGroupTableViewCell
        let group = filteredGroups[indexPath.row]
        cell.groupNameLabel.text = group.name
        let placeholderImage = UIImage(named: "placeholder")!
        
        if let url = URL(string: group.imageURL){
            cell.groupImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Public
    
    func selectedGroup(row: Int) -> Group {
        return filteredGroups[row]
    }
    
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
        /**
        let filterClosure = {(group: Group) -> Bool in
            return group.name.lowercased().contains(searchText.lowercased())
        }
        filteredGroups = groups.filter(filterClosure)
        */
        if searchText.count < 2 {
            return
        }
        weak var weakSelf = self
        HTTPSessionManager.sharedInstance.performGroupsSearchRequest(text: searchText) { (data, urlResponse, error) in
            guard let data = data, let json = try? JSON(data: data) else {
                return
            }
            
            let array = json["response"].flatMap({Group(json: $0.1)})
            weakSelf?.filteredGroups = array.filter{$0.imageURL != ""}
            DispatchQueue.main.async {
                weakSelf?.tableView.reloadData()
            }
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
