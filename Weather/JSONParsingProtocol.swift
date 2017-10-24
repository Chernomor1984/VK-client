//
//  JSONParsingProtocol.swift
//  VK
//
//  Created by Eugene Khizhnyak on 24.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONParsingProtocol {
    func parseJSON(_ json: JSON) -> [AnyObject]
}
