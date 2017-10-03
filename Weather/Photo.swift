//
//  Photo.swift
//  VK
//
//  Created by Eugene Khizhnyak on 03.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photo: Object {
    @objc dynamic var photoURL: String!
    
    // MARK: - Init
    
    convenience init(_ json: JSON) {
        self.init()
        self.photoURL = json["src_big"].stringValue
    }
}
