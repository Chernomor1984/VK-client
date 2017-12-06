//
//  FriendsListWatchAppHandler.swift
//  VK
//
//  Created by Eugene Khizhnyak on 05.12.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import WatchConnectivity

class NewsListWatchAppHandler: NSObject {
    private var session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    let newsService = NewsService()
    
    // MARK: - Init
    
    override init() {
        super.init()
        session?.delegate = self
        session?.activate()
    }
    
    func requestNews(replyHandler: @escaping ([String : Any]) -> Void) {
        newsService.downloadNews{ (news) in
            let response: [[String : String]] = news.flatMap{ singleNews in
                let watchAppNews = [singleNews.photoURL ?? "" : singleNews.text ?? ""]
                return watchAppNews
            }
            replyHandler(["newsListReply" : response])
        }
    }
}

extension NewsListWatchAppHandler: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard let requestType = message["requestType"] as? String else {
            assertionFailure()
            print("Wrong type of requestType")
            return
        }
        
        if requestType == "newsListRequest" {
            self.requestNews(replyHandler: replyHandler)
        } else {
            replyHandler(["newsListReply" : ""])
        }
    }
}
