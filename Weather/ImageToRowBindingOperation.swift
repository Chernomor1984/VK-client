//
//  ImageToRowBindingOperation.swift
//  VK
//
//  Created by Eugene Khizhnyak on 31.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import UIKit

class ImageToRowBindingOperation: Operation {
    private let indexPath: IndexPath
    private let container: CellDataUpdating
    
    // MARK: - Init
    
    init(indexPath: IndexPath, container: UITableView) {
        self.indexPath = indexPath
        self.container = TableView(container)
    }
    
    init(indexPath: IndexPath, container: UICollectionView) {
        self.indexPath = indexPath
        self.container = CollectionView(container)
    }
    
    // MARK: - Main
    
    override func main() {
        guard let cachedImageOperation = dependencies[0] as? CachedImageOperation,
            let image = cachedImageOperation.outputImage else {
                return
        }
        container.updateCellImage(image: image, atIndexPath: indexPath)
    }
}

fileprivate protocol CellDataUpdating {
    func updateCellImage(image: UIImage, atIndexPath indexPath: IndexPath)
}

extension ImageToRowBindingOperation {
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
        }
    }
}
