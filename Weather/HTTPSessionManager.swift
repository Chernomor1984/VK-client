//
//  HTTPSessionManager.swift
//  VK
//
//  Created by Eugene Khizhnyak on 01.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation

final class HTTPSessionManager {
    var token: String
    
    // MARK: - Shared Instance
    
    static let sharedInstance = {
        return HTTPSessionManager()
    }()
    
    // MARK: - Init
    
    private init() {
        token = ""
    }
}
