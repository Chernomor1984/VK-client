//
//  FriendTableViewCell.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 22.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var item: FriendTableViewItem!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        item = FriendTableViewItem()
    }
}
