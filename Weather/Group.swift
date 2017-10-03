//
//  Group.swift
//  VK
//
//  Created by Eugene Khizhnyak on 03.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object {
    @objc dynamic var imageURL: String!
    @objc dynamic var name: String!
    @objc dynamic var membersCount = 0
    
    // MARK: - Init
    
    convenience init(json: JSON) {
        self.init()
        self.name = json["name"].stringValue
        self.imageURL = json["photo_medium"].stringValue
        self.membersCount = json["members_count"].intValue
    }
    
    // MARK: - Public
    
    override func isEqual(_ object: Any?) -> Bool {
        if let otherObject = object as? Group {
            return
                self.name == otherObject.name &&
                self.imageURL == otherObject.imageURL
        }
        return false
    }
}
