//
//  FileManagerExtension.swift
//  VK
//
//  Created by Eugene Khizhnyak on 27.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation

extension FileManager {
    func cacheDicrectoryURL() -> URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
}
