//
//  VKSaveWallPhotoOperation.swift
//  VK
//
//  Created by Eugene Khizhnyak on 24.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON

class VKSaveWallPhotoOperation: AsyncNetworkOperation {
    
    var userID: Int
    var mediaID: Int?
    
    // MARK: - Init
    
    init(userID: Int) {
        self.userID = userID
    }
    
    // MARK: - Overriden
    
    override func main() {
        guard let vkImageUploadingOperation = dependencies.first as? VKImageUploadingOperation else {
            print("VKSaveWallPhotoOperation finished with no or wrong dependencies")
            self.state = .finished
            return
        }
        
        guard let photo = vkImageUploadingOperation.photo,
        let hash = vkImageUploadingOperation.photoHash,
        let server = vkImageUploadingOperation.server else {
            print("VKSaveWallPhotoOperation finished with no uploading info")
            self.state = .finished
            return
        }
        
        let urlRequest = RequestFactory.vkSaveWallPhotoRequest(userID: userID, photo: photo, hash: hash, server: server)
        let completionHandler = { [weak self] (data: Data?, urlResponse: URLResponse?, error: Error?) in
            if let error = error {
                print("VKSaveWallPhotoOperation finished with error:\(error.localizedDescription)")
                self?.state = .finished
                return
            }
            
            guard let data = data, let json = try? JSON(data: data) else {
                print("VKSaveWallPhotoOperation finished with no data")
                self?.state = .finished
                return
            }
            if let array = json["response"].array, let dict = array.first {
                self?.mediaID = dict["id"].int
            }
            self?.state = .finished
        }
        dataTask = HTTPSessionManager.sharedInstance.dataTask(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTask.resume()
        state = .executing
    }
}
