//
//  TableViewController1.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 19.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class TableViewController1: UITableViewController {
    
    let items = ["cell1", "cell2", "cell3"]
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    // MARK: - Navigation
}
