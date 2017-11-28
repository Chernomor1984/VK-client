//
//  TableViewController1.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 19.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit
import AlamofireImage
import RealmSwift

class FriendsListController: UITableViewController {
    @IBOutlet weak var requestsButton: UIBarButtonItem!
    var friends: Results<User>!
    var token: NotificationToken?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "AppOpenURL"), object: UIApplication.shared.delegate, queue: OperationQueue.main) { [weak self] (notification) in
            self?.requestsButton.isEnabled = UserDefaults.standard.object(forKey: newFriendsIdsKey) != nil
        }
        loadFriendsFromCache()
        loadFriendsList()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestsButton.isEnabled = UserDefaults.standard.object(forKey: newFriendsIdsKey) != nil
    }
    
    // MARK: - Private
    
    private func loadFriendsFromCache() {
        weak var weakSelf = self
        let completionHandler = { (users: Results<User>?, error: Error?) -> Void in
            if let error = error {
                print("loadFriendsFromCache error: \(error.localizedDescription)")
                return
            }
            weakSelf?.friends = users
            weakSelf?.token = weakSelf?.friends.observe({[weak self] (changes: RealmCollectionChange) in
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
        Storage.sharedInstance.loadFriendsFromCache(completionHandler: completionHandler)
    }
    
    private func loadFriendsList() {
        HTTPSessionManager.sharedInstance.performFriendsListRequest { error in
            if let error = error {
                print("loadFriendsList error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! FriendTableViewCell
        let user = friends[indexPath.row]
        cell.nameLabel.text = user.userFirstName + " " + user.userLastName
        let placeholderImage = UIImage(named: "placeholder")!
        
        if let url = URL(string: user.userPhotoURL){
            cell.avatarImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let objectToDelete = friends[indexPath.row]
            Storage.sharedInstance.removeObject(objectToDelete)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "didSelectFriend"{
            let navigationController = segue.destination as! UINavigationController
            let friendAvatarController = navigationController.viewControllers[0] as! FriendAvatarController
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let user = friends[selectedIndexPath.row]
                
                if let userID = Int(user.userID){
                    friendAvatarController.userID = userID
                }
                friendAvatarController.selectedName = user.userFirstName + " " + user.userLastName
            }
        }
    }
    
    @IBAction func closeCurrentControllerTapHandler(unwindSegue: UIStoryboardSegue) {
    }
}
