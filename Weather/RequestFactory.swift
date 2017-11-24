//
//  RequestFactory.swift
//  VK
//
//  Created by Eugene Khizhnyak on 01.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import UIKit

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
            URLQueryItem(name: "scope", value: "270342"),
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
            URLQueryItem(name: "user_id", value: UserDefaults.standard.string(forKey: userIDKey)),
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
            URLQueryItem(name: "album_id", value: "profile"),
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
            URLQueryItem(name: "access_token", value: UserDefaults.standard.string(forKey: tokenKey))
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    class func groupsSearchRequest(text: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "sort", value: "0"),
            URLQueryItem(name: "access_token", value: UserDefaults.standard.string(forKey: tokenKey))
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    class func newsfeedRequest(startTime: String, newsCount: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/newsfeed.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "start_time", value: startTime),
            URLQueryItem(name: "count", value: newsCount),
            URLQueryItem(name: "access_token", value: UserDefaults.standard.string(forKey: tokenKey)),
            URLQueryItem(name: "v", value: "5.68")
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    class func vkServerAddressRequest(groupID: Int) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/photos.getWallUploadServer"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: UserDefaults.standard.string(forKey: tokenKey)),
            URLQueryItem(name: "v", value: "5.68")
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    class func vkImageUploadingRequest(serverURL: URL, data: Data) -> URLRequest {
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        let fileName = "image.png"
        let mimetype = "image/png"
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"photo\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        return request
    }
    
    class func vkSaveWallPhotoRequest(userID: Int, photo: String, hash: String, server: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/photos.saveWallPhoto"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_id", value: String(userID)),
            URLQueryItem(name: "photo", value: photo),
            URLQueryItem(name: "server", value: server),
            URLQueryItem(name: "hash", value: hash),
            URLQueryItem(name: "access_token", value: UserDefaults.standard.string(forKey: tokenKey)),
            URLQueryItem(name: "v", value: "5.68")
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    class func vkWallPostRequest(ownerID: Int, message: String?, attachments: String?) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/wall.post"
        var queryItems = [
            URLQueryItem(name: "owner_id", value: String(ownerID)),
            URLQueryItem(name: "access_token", value: UserDefaults.standard.string(forKey: tokenKey)),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        if let message = message {
            queryItems.append(URLQueryItem(name: "message", value: message))
        }
        
        if let attachments = attachments {
            queryItems.append(URLQueryItem(name: "attachments", value: attachments))
        }
        urlComponents.queryItems = queryItems
        
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
}
