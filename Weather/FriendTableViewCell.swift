//
//  FriendTableViewCell.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 22.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell, ImageViewCellProtocol {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func imageView() -> UIImageView? {
        return avatarImageView
    }
}
