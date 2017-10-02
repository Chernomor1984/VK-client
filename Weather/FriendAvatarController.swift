//
//  CollectionViewController.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 19.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cellIdentifier"

class FriendAvatarController: UICollectionViewController {
    var userID = Int.min
    var selectedName = ""

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = selectedName
        loadPhotos()
    }
    
    // MARK: - Private
    
    private func loadPhotos() {
        HTTPSessionManager.sharedInstance.performPhotosListRequest(ownerID: userID) { (data, response, error) in
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) else {
                return
            }
            let dictionary = json as! [String: Any]
            let photosArray = dictionary["response"] as! [[String:AnyObject]]
            print(photosArray)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AvatarCollectionViewCell
//        cell.avatarImageView.image = UIImage(named:selectedAvatarName)
        return cell
    }
}
