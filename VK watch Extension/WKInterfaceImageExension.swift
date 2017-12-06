//
//  WKInterfaceImageExension.swift
//  VK watch Extension
//
//  Created by Eugene Khizhnyak on 06.12.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import WatchKit

extension WKInterfaceImage {
    public func imageFromUrl(_ urlString: String?) {
        if let urlString = urlString, let url = NSURL(string: urlString) {
            let request = NSURLRequest(url: url as URL)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if let imageData = data as Data? {
                    DispatchQueue.main.async {
                        self.setImageData(imageData)
                    }
                }
            });
            task.resume()
        }
    }
}
