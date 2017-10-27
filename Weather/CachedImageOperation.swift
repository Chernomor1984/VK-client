//
//  CachedImageOperation.swift
//  VK
//
//  Created by Eugene Khizhnyak on 27.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation

class CachedImageOperation: Operation {
    private let cacheLifeTime: TimeInterval = 86400 // сутки
    private static let path: String = {
        let path = "imageCache"
        
        guard let cacheDicrectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return path
        }
        
        let url = cacheDicrectory.appendingPathComponent(path, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("createDirectory error:\(error)")
            }
        }
        
        return path
    }()
}
