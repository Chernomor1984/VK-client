//
//  NewsFeedTableViewCell.swift
//  VK
//
//  Created by Eugene Khizhnyak on 17.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell, ImageViewCellProtocol {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var repostCountLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    
    func imageView() -> UIImageView? {
        return newsImageView
    }
}
