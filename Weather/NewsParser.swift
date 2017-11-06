//
//  NewsParser.swift
//  VK
//
//  Created by Eugene Khizhnyak on 24.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsParser: JSONParsingProtocol {
    
    let newsParsingClosure = { (json: JSON) -> News in
        var news = News()
        
        news.postID = json["post_id"].intValue
        let photoAttachments = json["attachments"].filter({ $0.1["type"] == "photo" })
        
        if let photo = photoAttachments.first?.1 {
            let attachmentType = photo["type"].stringValue
            news.photoURL = photo[attachmentType]["photo_604"].stringValue
        }
    
        news.likesCount = json["likes"]["count"].intValue
        news.repostsCount = json["reposts"]["count"].intValue
        news.commentsCount = json["comments"]["count"].intValue
        news.viewsCount = json["views"]["count"].intValue
        news.text = json["text"].stringValue
        
        return news
    }
    
    let filterClosure = { (news: News) -> Bool in
        guard let url = news.photoURL, let text = news.text else {
            return false
        }
        return news.photoURL?.count != 0 || news.text?.count != 0
    }
    
    // MARK: - Public
    
    func parseJSON(_ json: JSON) -> [AnyObject] {
        return json["response"]["items"].flatMap({ newsParsingClosure($0.1) }).filter({ filterClosure($0) })
    }
}
