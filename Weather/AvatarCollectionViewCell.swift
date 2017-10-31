//
//  AvatarCollectionViewCell.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 22.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell, ImageViewCellProtocol {
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func imageView() -> UIImageView? {
        return avatarImageView
    }
}
