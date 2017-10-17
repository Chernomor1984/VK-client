//
//  News.swift
//  VK
//
//  Created by Eugene Khizhnyak on 17.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class News: Object {
    @objc dynamic var postID: String!
    @objc dynamic var title: String!
    @objc dynamic var text: String!
    @objc dynamic var photoURL: String!
    
    // MARK: - Init
    
    convenience init(json: JSON) {
        self.init()
        self.postID = json["post_id"].stringValue
        self.text = json["text"].stringValue
        self.title = json["attachments"].stringValue
        self.photoURL = json["attachments"]["photo"]["photo_604"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "postID"
    }
}
