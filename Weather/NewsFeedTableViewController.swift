//
//  NewsFeedTableViewController.swift
//  VK
//
//  Created by Eugene Khizhnyak on 17.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit
import AlamofireImage
import RealmSwift

class NewsFeedTableViewController: UITableViewController {

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewsFeed()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        return cell
    }
    
    // MARK: - Private
    
    private func loadNewsFeed() {
        HTTPSessionManager.sharedInstance.performNewsFeedRequest(startTime: "1508241600", newsCount: "100") { error in
            if let error = error {
                print("loadNewsFeed error: \(error.localizedDescription)")
                return
            }
        }
    }
}
