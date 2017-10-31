//
//  DownloadServiceProtocol.swift
//  VK
//
//  Created by Eugene Khizhnyak on 31.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import UIKit

protocol DownloadServiceProtocol {
    func readLocalCachedImage(identifier: String) -> UIImage?
    
    func addImageToLocalCache(image: UIImage, identifier: String)
}
