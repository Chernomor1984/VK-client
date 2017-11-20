//
//  LocationServiceDelegate.swift
//  VK
//
//  Created by Eugene Khizhnyak on 20.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    func didUpdateLocations(locationService: LocationService, coordinates: CLLocationCoordinate2D)
}
