//
//  Photo.swift
//  VK
//
//  Created by Eugene Khizhnyak on 03.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON

class Photo {
    var photoURL: URL!
    
    // MARK: - Init
    
    init(_ json: JSON) {
        self.photoURL = URL(string: json["src_big"].stringValue)
    }
}
