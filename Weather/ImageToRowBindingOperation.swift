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
    
    init(indexPath: IndexPath, container: CellDataUpdating) {
        self.indexPath = indexPath
        self.container = container
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

