//
//  LoadFriendsRequestsIDOperation.swift
//  VK extension
//
//  Created by Eugene Khizhnyak on 28.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation

class LoadFriendsRequestsIDOperation: AsyncNetworkOperation {
    var userIDs: String?
    var count = 0
    
    private var token = ""
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    lazy var url: URL? = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.getRequests"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.68")
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request.url
    }()
    
    // MARK: - Overriden
    
    override func main() {
        guard let token = UserDefaults(suiteName: "group.com.rcntec.VK")?.string(forKey: "tokenKey") else {
            assertionFailure()
            self.state = .finished
            return
        }
        
        self.token = token
        guard let url = url else {
            assertionFailure()
            self.state = .finished
            return
        }
        session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("LoadFriendsRequestsIDOperation failed:\(error.localizedDescription)")
                self?.state = .finished
                return
            }
            
            guard let data = data else {
                assertionFailure()
                self?.state = .finished
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                var dict = json as? [String : Any]
                
                if let dict = dict?["response"] as? [String : Any], let items = dict["items"] as? [Int] {
                    self?.userIDs = String(items.map{String($0)}.joined(separator: ","))
                    self?.count = dict["count"] as! Int
                }
            } catch {
                print("LoadFriendsRequestsIDOperation failed:\(error.localizedDescription)")
            }
            self?.state = .finished
            }.resume()
    }
}
