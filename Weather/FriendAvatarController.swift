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
        loadPhotos()
    }
    
    // MARK: - Private
    
    private func loadPhotos() {
        weak var weakSelf = self
        HTTPSessionManager.sharedInstance.performPhotosListRequest(ownerID: userID) { (data, response, error) in
            guard let data = data else {
                return
            }
            let json = JSON(data)
            weakSelf?.photos = json["response"].flatMap{Photo($0.1)}
            DispatchQueue.main.async {
                weakSelf?.collectionView?.reloadData()
            }
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
        cell.avatarImageView.af_setImage(withURL: photo.photoURL, placeholderImage: placeholderImage)
        return cell
    }
}
