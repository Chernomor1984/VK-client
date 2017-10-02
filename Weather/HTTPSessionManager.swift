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
    var userID: String
    let urlSession: URLSession
    
    // MARK: - Shared Instance
    
    static let sharedInstance = {
        return HTTPSessionManager()
    }()
    
    // MARK: - Init
    
    private init() {
        token = ""
        userID = ""
        let defaultConfiguration = URLSessionConfiguration.default
        urlSession = URLSession(configuration: defaultConfiguration)
    }
    
    // MARK: - Public
    
    func performFriendsListRequest(completionHandler: @escaping(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void) {
        let urlRequest = RequestFactory.vkFriendsListRequest()
        let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: completionHandler)
        dataTask.resume()
    }
    
    func performPhotosListRequest(ownerID: Int, completionHandler: @escaping(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void) {
        let urlRequest = RequestFactory.photosListRequest(ownerID: ownerID)
        let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: completionHandler)
        dataTask.resume()
    }
}
