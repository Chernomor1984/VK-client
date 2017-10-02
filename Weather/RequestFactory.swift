//
//  RequestFactory.swift
//  VK
//
//  Created by Eugene Khizhnyak on 01.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation

class RequestFactory {
    
    class func vkAuthRequest(clientID: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    class func vkFriendsListRequest() -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: HTTPSessionManager.sharedInstance.userID),
            URLQueryItem(name: "order", value: "random"),
            URLQueryItem(name: "fields", value: "nickname, domain, sex, bdate, city, country, photo_50, contacts, education, relation, status, universities")
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    class func photosListRequest(ownerID: Int) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/photos.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "owner_id", value: String(ownerID)),
            URLQueryItem(name: "album_id", value: "wall"),
            URLQueryItem(name: "rev", value: "0")
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    class func groupsListRequest(userID: Int) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: String(userID)),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "members_count"),
            URLQueryItem(name: "access_token", value: HTTPSessionManager.sharedInstance.token)
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
}
