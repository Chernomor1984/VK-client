//
//  GroupDB.swift
//  VK
//
//  Created by Eugene Khizhnyak on 07.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation

struct GroupDB: Codable {
    let groupName: String
    
    var anyObject: Any {
        return ["groupName" : groupName]
    }
}
