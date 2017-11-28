//
//  NewFriendsBackgroundFetchService.swift
//  VK
//
//  Created by Eugene Khizhnyak on 28.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import UIKit

let newFriendsIdsKey = "new friends ids"
let lastUpdateKey = "lastUpdateKey"
let minFetchTime: TimeInterval = 60.0 // a minute
typealias AppDelegateBGCompletion = (UIBackgroundFetchResult) -> Void

class NewFriendsBackgroundFetchService {
    private var timer: DispatchSourceTimer?
    private var lastUpdate: Date? {
        get {
            return UserDefaults.standard.object(forKey: lastUpdateKey) as? Date
        }
        set {
            UserDefaults.standard.set(Date(), forKey: lastUpdateKey)
        }
    }
    
    // MARK: - Public
    
    func startFetch(completion: @escaping AppDelegateBGCompletion) {
        print ("Старт обновления данных в фоне \(Date())")
        if lastUpdate != nil, abs(lastUpdate!.timeIntervalSinceNow) < minFetchTime {
            print ("Фоновое обновление не требуется, т.к. данные последний раз данные обновлялись \(abs(lastUpdate!.timeIntervalSinceNow)) секунд назад (меньше \(minFetchTime) секунд назад)")
            completion(.noData)
            return
        }
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer?.schedule(deadline: .now(), repeating: .seconds(Int(minFetchTime) - 1), leeway: .seconds(1))
        timer?.setEventHandler {
            print ("Загрузить данные не удалось")
            completion(.failed)
            return
        }
        timer?.resume()
        fetchFriendsRequests(completion)
    }
    
    // MARK: - Private
    
    private func fetchFriendsRequests(_ completion: @escaping AppDelegateBGCompletion) {
        HTTPSessionManager.sharedInstance.performBackgroundFriendsRequest { [weak self] (data, response, error) in
            if let error = error {
                print("NewFriendsBackgroundFetchService fetchFriendsRequests failed: \(error.localizedDescription)")
                return
            }
            
            if data != nil {
                UserDefaults.standard.setValue(data!, forKey: newFriendsIdsKey)
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = 1
                }
            }
            self?.timer?.cancel()
            self?.timer = nil
            self?.lastUpdate = Date()
            completion(.newData)
            print("Данные загружены")
        }
    }
}
