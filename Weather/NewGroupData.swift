//
//  NewGroupData.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 22.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class NewGroupData: NSObject {
    var groupName = ""
    var avatarName = ""
    var membersCount = 0
    
    // MARK: - Init
    
    init(_ groupName: String, avatarName: String, membersCount: Int) {
        self.groupName = groupName
        self.avatarName = avatarName
        self.membersCount = membersCount
    }
    
    // MARK: - Public
    
    override func isEqual(_ object: Any?) -> Bool {
        if let otherObject = object as? NewGroupData {
            return
                self.groupName == otherObject.groupName &&
                self.avatarName == otherObject.avatarName &&
                    self.membersCount == otherObject.membersCount
        }
        return false
    }
}
