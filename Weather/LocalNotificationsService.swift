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
    
    private let newFriendsRequestNotificationIdentifier = "newFriendsRequestNotificationIdentifier"
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
    
    func addNewFriendsRequestNotification(title: String?, body: String, badge: NSNumber?, sound: UNNotificationSound? = UNNotificationSound.default()) {
        let content = UNMutableNotificationContent()
        content.body = body
        
        if let title = title {
            content.title = title
        }
        
        if let badge = badge {
            content.badge = badge
        }
        
        if let sound = sound {
            content.sound = sound
        }
        
        let request = UNNotificationRequest(identifier: newFriendsRequestNotificationIdentifier, content: content, trigger: nil)
        let completionHandler = { (error: Error?) in
            if let error = error {
                assertionFailure("UNUserNotificationCenter newFriendsRequestNotification failed with error:\(error.localizedDescription)")
            }
        }
        center.add(request, withCompletionHandler: completionHandler)
    }
}
