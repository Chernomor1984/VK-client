//
//  NewsService.swift
//  VK
//
//  Created by Eugene Khizhnyak on 24.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsService {
    let newsParser = NewsParser()
    
    func downloadNews(completion: @escaping([News]) -> Void) {
        weak var weakSelf = self
        DispatchQueue.global(qos: .userInteractive).async {
            let date = Date().dateByAdding(-3)
            let roundedTimeInterval = Int(Date().timeIntervalForDate(date))
            let stringInterval = String(roundedTimeInterval)
            HTTPSessionManager.sharedInstance.performNewsFeedRequest(startTime: stringInterval, newsCount: "100", completionHandler: { (data, response, error) in
                if let error = error {
                    print("downloadNews error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    return
                }
                let json = JSON(data: data)
                let news = weakSelf?.newsParser.parseJSON(json) as? [News]
                
                DispatchQueue.main.async {
                    completion(news ?? [])
                }
            })
        }
    }
}
