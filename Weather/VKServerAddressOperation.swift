//
//  VKServerAddressOperation.swift
//  VK
//
//  Created by Eugene Khizhnyak on 24.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON

class VKServerAddressOperation: AsyncNetworkOperation {
    private var urlRequest: URLRequest?
    var uploadingServerAddress: String?
    
    // MARK: - Init
    
    init(with request: URLRequest) {
        self.urlRequest = request
    }
    
    override func main() {
        guard let urlRequest = urlRequest else {
            state = .finished
            return
        }
        
        let completionHandler = { [weak self] (data: Data?, urlResponse: URLResponse?, error: Error?) in
            if let error = error {
                print("VKServerAddressOperation finished with error:\(error.localizedDescription)")
                self?.state = .finished
                return
            }
            
            guard let data = data, let json = try? JSON(data: data) else {
                print("VKServerAddressOperation finished with no data")
                self?.state = .finished
                return
            }
            self?.uploadingServerAddress = json["response"]["upload_url"].string
            self?.state = .finished
        }
        dataTask = HTTPSessionManager.sharedInstance.dataTask(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTask.resume()
        state = .executing
    }
}
