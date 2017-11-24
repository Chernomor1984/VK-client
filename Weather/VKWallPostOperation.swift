//
//  VKWallPostOperation.swift
//  VK
//
//  Created by Eugene Khizhnyak on 25.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON

class VKWallPostOperation: AsyncNetworkOperation {
    
    private var ownerID: Int
    private var mediaType: String
    private var message: String?
    
    // MARK: - Init
    
    init(ownerID: Int, mediaTypeArray: String, message: String?) {
        self.ownerID = ownerID
        self.mediaType = mediaTypeArray
        self.message = message
    }
    
    // MARK: - Overriden
    
    override func main() {
        guard let vkSaveWallPhotoOperation = dependencies.first as? VKSaveWallPhotoOperation else {
            print("VKWallPostOperation finished with no or wrong dependencies")
            self.state = .finished
            return
        }
        
        guard let mediaID = vkSaveWallPhotoOperation.mediaID else {
            print("VKWallPostOperation finished with no media id")
            self.state = .finished
            return
        }
        
        let stringMediaID = String(mediaID)
        let stringOwnerID = String(ownerID)
        let attachments = mediaType + stringOwnerID + "_" + stringMediaID
        let urlRequest = RequestFactory.vkWallPostRequest(ownerID: ownerID, message: message, attachments: attachments)
        let completionHandler = { [weak self] (data: Data?, urlResponse: URLResponse?, error: Error?) in
            if let error = error {
                print("VKWallPostOperation finished with error:\(error.localizedDescription)")
                self?.state = .finished
                return
            }
            self?.state = .finished
        }
        dataTask = HTTPSessionManager.sharedInstance.dataTask(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTask.resume()
        state = .executing
    }
}
