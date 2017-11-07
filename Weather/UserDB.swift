//
//  UserDB.swift
//  VK
//
//  Created by Eugene Khizhnyak on 07.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation

struct UserDB {
    let userID: String
    var groups: [GroupDB]
    
    var anyObject: Any {
        return ["\(userID)" : userID,
                "groups" : groups.map{ $0.anyObject }]
    }
}
