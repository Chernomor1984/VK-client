//
//  HTTPSessionManager.swift
//  VK
//
//  Created by Eugene Khizhnyak on 01.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias completionHandlerClosure = (_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void
typealias errorCompletionHandlerClosure = (_ error: Error?) -> Void

final class HTTPSessionManager {
    let urlSession: URLSession
    
    // MARK: - Shared Instance
    
    static let sharedInstance = {
        return HTTPSessionManager()
    }()
    
    // MARK: - Init
    
    private init() {
        let defaultConfiguration = URLSessionConfiguration.default
        urlSession = URLSession(configuration: defaultConfiguration)
    }
    
    // MARK: - Public
    
    func performFriendsListRequest(completionHandler: @escaping errorCompletionHandlerClosure) {
        let urlRequest = RequestFactory.vkFriendsListRequest()
        let completion = { (_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void in
            guard let data = data else {
                return
            }
            
            let json = JSON(data: data)
            let friends = json["response"].flatMap({User(json: $0.1)})
            Storage.sharedInstance.importFriends(friends, completion: completionHandler)
        }
        let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: completion)
        dataTask.resume()
    }
    
    func performPhotosListRequest(ownerID: Int, completionHandler: @escaping errorCompletionHandlerClosure) {
        let urlRequest = RequestFactory.photosListRequest(ownerID: ownerID)
        let completion = { (_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void in
            guard let data = data else {
                return
            }
            let json = JSON(data)
            let photos = json["response"].flatMap{Photo($0.1)}
            Storage.sharedInstance.importPhotos(ownerID: String(ownerID), photos, completion: completionHandler)
        }
        let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: completion)
        dataTask.resume()
    }
    
    func performGroupsListRequest(userID: Int, completionHandler: @escaping errorCompletionHandlerClosure) {
        let urlRequest = RequestFactory.groupsListRequest(userID: userID)
        let completion = { (_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void in
            guard let data = data else {
                return
            }
            
            let json = JSON(data: data)
            let array = json["response"].flatMap({Group(json: $0.1)})
            let groups = array.filter{$0.imageURL != ""}
            Storage.sharedInstance.importGroups(groups, completion: completionHandler)
        }
        let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: completion)
        dataTask.resume()
    }
    
    func performGroupsSearchRequest(text: String, completionHandler: @escaping completionHandlerClosure) {
        let urlRequest = RequestFactory.groupsSearchRequest(text: text)
        let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: completionHandler)
        dataTask.resume()
    }
    
    func performNewsFeedRequest(startTime: String, newsCount: String, completionHandler: @escaping completionHandlerClosure) {
        let urlRequest = RequestFactory.newsfeedRequest(startTime: startTime, newsCount: newsCount)
        let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: completionHandler)
        dataTask.resume()
    }
}
