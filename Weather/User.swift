//
//  User.swift
//  VK
//
//  Created by Eugene Khizhnyak on 02.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class User: Object {
    @objc dynamic var userID: String!
    @objc dynamic var userPhotoURL: String!
    @objc dynamic var userFirstName: String!
    @objc dynamic var userLastName: String!
    
    // MARK: - Init
    
    convenience init(json: JSON) {
        self.init()
        self.userID = json["user_id"].stringValue
        self.userPhotoURL = json["photo_50"].stringValue
        self.userFirstName = json["first_name"].stringValue
        self.userLastName = json["last_name"].stringValue
    }
}
