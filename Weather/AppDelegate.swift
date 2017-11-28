//
//  AppDelegate.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 12.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import GoogleMaps
import GooglePlaces

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let googleMapsKey = "AIzaSyCewIm88BUch14Cr0LdbUsqAPqgEClf5kY"
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        FirebaseApp.configure()
        GMSServices.provideAPIKey(googleMapsKey)
        GMSPlacesClient.provideAPIKey(googleMapsKey)
        let settings = UIUserNotificationSettings(types: .badge, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let newFriendsFetchService = NewFriendsBackgroundFetchService()
        newFriendsFetchService.startFetch(completion: completionHandler)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AppOpenURL"), object: self, userInfo: nil)
        return true
    }
}

