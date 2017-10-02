//
//  User.swift
//  VK
//
//  Created by Eugene Khizhnyak on 02.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    var userID: String!
    var userPhotoURL: URL!
    var userFirstName: String!
    var userLastName: String!
    
    // MARK: - Init
    
    init(json: JSON) {
        self.userID = json["user_id"].stringValue
        self.userPhotoURL = URL(fileURLWithPath: json["photo_50"].stringValue)
        self.userFirstName = json["first_name"].stringValue
        self.userLastName = json["last_name"].stringValue
    }
}
