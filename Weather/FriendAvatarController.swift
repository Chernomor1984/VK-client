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

private let reuseIdentifier = "cellIdentifier"

class FriendAvatarController: UICollectionViewController {
    var userID = Int.min
    var selectedName = ""
    var photos = [Photo]()

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
        let completionHandler = { (photos: [Photo]?, error: Error?) -> Void in
            if let error = error {
                print("loadFriendsFromCache error: \(error.localizedDescription)")
                return
            }
            weakSelf?.photos = photos!
            DispatchQueue.main.async {
                weakSelf?.collectionView?.reloadData()
            }
        }
        Storage.sharedInstance.loadPhotosFromCache(ownerID: String(userID), completionHandler: completionHandler)
    }
    
    private func loadPhotos() {
        weak var weakSelf = self
        HTTPSessionManager.sharedInstance.performPhotosListRequest(ownerID: userID) { error in
            if let error = error {
                print("loadFriendsFromCache error: \(error.localizedDescription)")
                return
            }
            weakSelf?.loadPhotosFromCache()
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
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
