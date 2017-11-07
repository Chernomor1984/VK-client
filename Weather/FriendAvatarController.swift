//
//  CollectionViewController.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 19.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlamofireImage
import RealmSwift

private let reuseIdentifier = "cellIdentifier"

class FriendAvatarController: UICollectionViewController {
    var userID = Int.min
    var selectedName = ""
    var photos: Results<Photo>!
    var token: NotificationToken?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = selectedName
        loadPhotosFromCache()
        loadPhotos()
    }
    
    // MARK: - Private
    
    private func loadPhotosFromCache() {
        weak var weakSelf = self
        let completionHandler = { (photos: Results<Photo>?, error: Error?) -> Void in
            if let error = error {
                print("loadFriendsFromCache error: \(error.localizedDescription)")
                return
            }
            weakSelf?.photos = photos
            weakSelf?.token = weakSelf?.photos.observe{[weak self] (changes: RealmCollectionChange) in
                switch changes {
                case .initial:
                    self?.collectionView?.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self?.collectionView?.performBatchUpdates({
                        self?.collectionView?.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                        self?.collectionView?.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                        self?.collectionView?.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                    }, completion: nil)
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        }
        Storage.sharedInstance.loadPhotosFromCache(ownerID: String(userID), completionHandler: completionHandler)
    }
    
    private func loadPhotos() {
        HTTPSessionManager.sharedInstance.performPhotosListRequest(ownerID: userID) { error in
            if let error = error {
                print("loadFriendsFromCache error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AvatarCollectionViewCell
        let photo = photos[indexPath.row]
        let placeholderImage = UIImage(named: "placeholder")!
        
        if let url = URL(string: photo.photoURL){
            cell.avatarImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
        return cell
    }
}
