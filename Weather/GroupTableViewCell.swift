//
//  GroupTableViewCell.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 22.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell, ImageViewCellProtocol {
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    func imageView() -> UIImageView? {
        return groupImageView
    }
}
