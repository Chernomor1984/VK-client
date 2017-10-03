//
//  Group.swift
//  VK
//
//  Created by Eugene Khizhnyak on 03.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON

class Group: NSObject {
    var imageURL: URL!
    var name: String!
    var membersCount: Int!
    
    // MARK: - Init
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.imageURL = URL(string: json["photo_medium"].stringValue)
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
