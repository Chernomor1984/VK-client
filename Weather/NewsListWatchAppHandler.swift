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
    
    // MARK: - Init
    
    override init() {
        super.init()
        session?.delegate = self
        session?.activate()
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
        replyHandler(["test" : "test"])
    }
}
