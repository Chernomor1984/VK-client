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
    
    var uploadingServerAddress: String?
    
    override func main() {
        guard let urlRequest = urlRequest else {
            state = .finished
            return
        }
        
        let completionHandler = { [weak self] (data: Data?, urlResponse: URLResponse?, error: Error?) in
            if let error = error {
                print("AsyncDownloadOperation finished with error:\(error.localizedDescription)")
                self?.state = .finished
                return
            }
            
            guard let data = data, let json = try? JSON(data: data) else {
                print("AsyncDownloadOperation finished with no data")
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
