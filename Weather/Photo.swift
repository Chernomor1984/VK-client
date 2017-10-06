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
    @objc dynamic var ownerID: String!
    @objc dynamic var photoURL: String!
    
    // MARK: - Init
    
    convenience init(_ json: JSON) {
        self.init()
        self.ownerID = String(json["owner_id"].intValue)
        self.photoURL = json["src_big"].stringValue
    }
}
