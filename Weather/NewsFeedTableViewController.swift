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
    
    let newsService = NewsService()
    var news = [News]()
    lazy var photoService: PhotoDownloadService = PhotoDownloadService(container: tableView)
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        newsService.downloadNews{ [weak self] (news) in
            self?.news = news
            self?.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! NewsFeedTableViewCell
        let news = self.news[indexPath.row]
        
        cell.newsTextLabel.text = news.text ?? ""
        cell.commentCountLabel.text = String(describing: news.commentsCount ?? 0)
        cell.likeCountLabel.text = String(describing: news.likesCount ?? 0)
        cell.repostCountLabel.text = String(describing: news.repostsCount ?? 0)
        cell.viewsCountLabel.text = String(describing: news.viewsCount ?? 0)
        
        if let stringPhotoURL = news.photoURL {
            photoService.loadPhoto(url: stringPhotoURL, indexPath: indexPath)
        } else {
            cell.newsImageView.image = nil
        }
        
        return cell
    }
    
    //MARK: - Actions
    
    @IBAction func closeAddPostContrller(unwindSegue: UIStoryboardSegue){
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private
    
    private func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 10
    }
}
