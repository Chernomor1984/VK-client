//
//  VKImageUploadingOperation.swift
//  VK
//
//  Created by Eugene Khizhnyak on 24.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

import Alamofire

class VKImageUploadingOperation: AsyncNetworkOperation {
    
    var photo: String?
    var photoHash: String?
    var server: String?
    private var image: UIImage?
    
    // MARK: - Init
    
    init(image: UIImage) {
        self.image = image
    }
    
    override func main() {
        guard let serverAddressOperation = dependencies.first as? VKServerAddressOperation,
            let stringURL = serverAddressOperation.uploadingServerAddress,
            let url = URL(string: stringURL) else {
                print("VKImageUploadingOperation finished with no server url")
                self.state = .finished
                return
        }
        
        guard let image = image, let imageData = UIImagePNGRepresentation(image) else {
            print("VKImageUploadingOperation failed: no image data available")
            return
        }
        
        let urlRequest = RequestFactory.vkImageUploadingRequest(serverURL: url, data: imageData)
        let completionHandler = { [weak self] (data: Data?, urlResponse: URLResponse?, error: Error?) in
            if let error = error {
                print("VKImageUploadingOperation finished with error:\(error.localizedDescription)")
                self?.state = .finished
                return
            }
            
            guard let data = data, let json = try? JSON(data: data) else {
                print("VKImageUploadingOperation finished with no data")
                self?.state = .finished
                return
            }
            self?.photo = json["photo"].string
            self?.photoHash = json["hash"].string
            
            if let server = json["server"].int {
                self?.server = String(describing: server)
            }

            self?.state = .finished
        }
        dataTask = HTTPSessionManager.sharedInstance.dataTask(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTask.resume()
        state = .executing
    }
}
