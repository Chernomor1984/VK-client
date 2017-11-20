//
//  LocationService.swift
//  VK
//
//  Created by Eugene Khizhnyak on 20.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    static let sharedInstance = LocationService()
    weak var delegete: LocationServiceDelegate?
    
    private override init() {}
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    // MARK: - Public
    
    func startUpdateLocations() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocations() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.last?.coordinate else {
            return
        }
        delegete?.didUpdateLocations(locationService: self, coordinates: coordinates)
    }
}
