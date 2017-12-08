//
//  LocalNotificationsService.swift
//  VK
//
//  Created by Eugene Khizhnyak on 08.12.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationsService {
    static let sharedInstance = LocalNotificationsService()
    
    private let center = UNUserNotificationCenter.current()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Public
    
    func registerForLocalNotifications() {
        center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            if let error = error {
                assertionFailure("UNUserNotificationCenter requestAuthorization failed with error:\(error.localizedDescription)")
                return
            }
            
            if granted {
                print("Local notifications enabled")
            } else {
                print("Local notifications disabled")
            }
        }
    }
}
