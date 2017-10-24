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
        return news
    }
    
    // MARK: - Public
    
    func parseJSON(_ json: JSON) -> [AnyObject] {
        return json["response"]["items"].flatMap({ newsParsingClosure($0.1) })
    }
}
