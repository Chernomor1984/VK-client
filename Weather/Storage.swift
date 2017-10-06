//
//  Storage.swift
//  VK
//
//  Created by Eugene Khizhnyak on 06.10.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import RealmSwift

final class Storage {
    
    let concurrentQueue = DispatchQueue.main
//    let concurrentQueue = DispatchQueue(label: "realmQueue")
    
    // MARK: - Shared Instance
    
    static let sharedInstance = {
        return Storage()
    }()
    
    // MARK: - Private
    
    private init() {
    }
    
    // MARK: - Public
    
    func loadFriendsFromCache(completionHandler: @escaping(_ users: [User]?, _ error: Error?) -> Void) {
        concurrentQueue.async {
            do {
                let realmInstance = try Realm()
                let friends = realmInstance.objects(User.self)
                completionHandler(Array(friends), nil)
            } catch {
                completionHandler(nil, error)
            }
        }
    }
    
    func importFriends(_ friends: [User], completion: @escaping(_ error: Error?) -> Void) -> Void {
        concurrentQueue.async {
            do {
                let realmInstance = try Realm()
                let oldFriends = realmInstance.objects(User.self)
                realmInstance.beginWrite()
                realmInstance.delete(oldFriends)
                realmInstance.add(friends)
                try realmInstance.commitWrite()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
