//
//  PhotoDownloadService.swift
//  VK
//
//  Created by Eugene Khizhnyak on 31.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import UIKit

class PhotoDownloadService: DownloadServiceProtocol {
    private var images = [String: UIImage]()
    private let accessQueue = DispatchQueue(label: "PhotoDownloadService", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global(qos: .userInteractive))
    private let container: CellDataUpdating
    
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    // MARK: - Init
    
    init(container: UITableView) {
        self.container = TableView(container)
    }
    
    init(container: UICollectionView) {
        self.container = CollectionView(container)
    }
    
    // MARK: - Public
    
    func loadPhoto(url: String, indexPath: IndexPath) {
        let cachedImageOperation = CachedImageOperation(url: url, service: self)
        let imageBindingOperation = ImageToRowBindingOperation(indexPath: indexPath, container: container)
        imageBindingOperation.addDependency(cachedImageOperation)
        operationQueue.addOperation(cachedImageOperation)
        OperationQueue.main.addOperation(imageBindingOperation)
    }
    
    // MARK: - DownloadServiceProtocol
    
    func readLocalCachedImage(identifier: String) -> UIImage? {
        var image: UIImage?
        accessQueue.async { [weak self] in
            image = self?.images[identifier]
        }
        return image
    }
    
    func addImageToLocalCache(image: UIImage, identifier: String) {
        accessQueue.async(flags: .barrier) { [weak self] in
            self?.images[identifier] = image
        }
    }
}

extension PhotoDownloadService {
    private class TableView: CellDataUpdating {
        let tableView: UITableView
        
        init(_ tableView: UITableView) {
            self.tableView = tableView
        }
        
        func updateCellImage(image: UIImage, atIndexPath indexPath: IndexPath) {
            guard let cell = tableView.cellForRow(at: indexPath) as? ImageViewCellProtocol,
                let imageView = cell.imageView() else {
                    return
            }
            imageView.image = image
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private class CollectionView: CellDataUpdating {
        let collectionView: UICollectionView
        
        init(_ collectionView: UICollectionView) {
            self.collectionView = collectionView
        }
        
        func updateCellImage(image: UIImage, atIndexPath indexPath: IndexPath) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ImageViewCellProtocol,
                let imageView = cell.imageView() else {
                    return
            }
            imageView.image = image
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

