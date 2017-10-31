//
//  CellDataUpdating.swift
//  VK
//
//  Created by Eugene Khizhnyak on 31.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import UIKit

protocol CellDataUpdating {
    func updateCellImage(image: UIImage, atIndexPath indexPath: IndexPath)
}
