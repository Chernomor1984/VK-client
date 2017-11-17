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
        return true
    }
}

