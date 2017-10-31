//
//  NewGroupTableViewCell.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 22.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class NewGroupTableViewCell: UITableViewCell, ImageViewCellProtocol {
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupImageView: UIImageView!
    
    func imageView() -> UIImageView? {
        return groupImageView
    }
}
