//
//  CachedImageOperation.swift
//  VK
//
//  Created by Eugene Khizhnyak on 27.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import UIKit

class CachedImageOperation: Operation {
    
    var outputImage: UIImage?
    
    private let url: String
    private let cacheLifeTime: TimeInterval = 86400 // сутки
    private let service: DownloadServiceProtocol
    
    private static let path: String = {
        let path = "imageCache"
        
        guard let cacheDicrectory = FileManager().cacheDicrectoryURL() else {
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
    
    private lazy var filePath: String? = {
        guard let cacheDirectory = FileManager().cacheDicrectoryURL() else {
            return nil
        }
        
        let hash = String(describing: url.hashValue)
        let pathComponent = CachedImageOperation.path + "/" + hash
        let filePath = cacheDirectory.appendingPathComponent(pathComponent)
        return filePath.path
    }()
    
    // MARK: - Init
    
    init(url: String, service: DownloadServiceProtocol) {
        self.url = url
        self.service = service
    }
    
    // MARK: - Main
    
    override func main() {
        if filePath == nil || isCancelled {
            return
        }
        
        if (readLocalCachedImage() || isCancelled){
            return
        }
        
        if readCachedImage() || isCancelled {
            return
        }
        
        if !downloadImage() || isCancelled {
            return
        }
        
        saveImageToCache()
    }
    
    // MARK: - Private
    
    private func readLocalCachedImage() -> Bool {
        let hash = String(describing: url.hashValue)
        
        guard let image = service.readLocalCachedImage(identifier: hash) else {
            return false
        }
        self.outputImage = image
        return true
    }
    
    private func readCachedImage() -> Bool {
        guard let fileName = filePath,
            let fileInfo = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = fileInfo[FileAttributeKey.modificationDate] as? Date else {
                return false
        }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime, let cacheImage = UIImage(contentsOfFile: fileName) else {
            return false
        }
        
        let hash = String(describing: url.hashValue)
        service.addImageToLocalCache(image: cacheImage, identifier: hash)
        self.outputImage = cacheImage
        return true
    }
    
    private func downloadImage() -> Bool {
        guard let url = URL(string: url),
        let imageData = try? Data(contentsOf: url),
            let image = UIImage(data: imageData) else {
                return false
        }
        
        self.outputImage = image
        return true
    }
    
    private func saveImageToCache() {
        guard let fileName = filePath, let image = outputImage else {
            return
        }
        
        let imageData = UIImagePNGRepresentation(image)
        FileManager.default.createFile(atPath: fileName, contents: imageData, attributes: nil)
    }
}
