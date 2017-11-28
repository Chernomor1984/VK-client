//
//  NewFriendRequest.swift
//  VK
//
//  Created by Eugene Khizhnyak on 28.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON

struct NewFriend {
    var name: String?
    var city: String?
    var imageURL: URL?
    
    // MARK: - Init
    
    init(json: JSON) {
        self.name = json["first_name"].stringValue + " " + json["last_name"].stringValue
        self.city = json["city"]["title"].stringValue
        let stringImageURL = json["photo_200"].stringValue
        self.imageURL = URL(string: stringImageURL)
    }
}
