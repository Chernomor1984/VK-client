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
    // MARK: - Shared Instance
    
    static let sharedInstance = {
        return Storage()
    }()
    
    // MARK: - Private
    
    private init() {
    }
    
    // MARK: - Public
    
    func loadPhotosFromCache(ownerID: String, completionHandler: @escaping(_ users: Results<Photo>?, _ error: Error?) -> Void) {
        do {
            let realmInstance = try Realm()
            let photos = realmInstance.objects(Photo.self).filter("ownerID == %@", ownerID)
            completionHandler(photos, nil)
        } catch {
            completionHandler(nil, error)
        }
    }
    
    func loadFriendsFromCache(completionHandler: @escaping(_ users: Results<User>?, _ error: Error?) -> Void) {
        do {
            let realmInstance = try Realm()
            let friends = realmInstance.objects(User.self)
            completionHandler(friends, nil)
        } catch {
            completionHandler(nil, error)
        }
    }
    
    func loadGroupsFromCache(completionHandler: @escaping(_ groups: Results<Group>?, _ error: Error?) -> Void) {
        do {
            let realmInstance = try Realm()
            let groups = realmInstance.objects(Group.self)
            completionHandler(groups, nil)
        } catch {
            completionHandler(nil, error)
        }
    }
    
    func importFriends(_ friends: [User], completion: @escaping(_ error: Error?) -> Void) -> Void {
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
    
    func importPhotos(ownerID: String, _ photos: [Photo], completion: @escaping(_ error: Error?) -> Void) -> Void {
        do {
            let realmInstance = try Realm()
            let oldPhotos = realmInstance.objects(Photo.self).filter("ownerID == %@", ownerID)
            realmInstance.beginWrite()
            realmInstance.delete(oldPhotos)
            realmInstance.add(photos)
            try realmInstance.commitWrite()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func importGroups(_ groups: [Group], completion: @escaping(_ error: Error?) -> Void) -> Void {
        do {
            let realmInstance = try Realm()
            let oldGroups = realmInstance.objects(Group.self)
            realmInstance.beginWrite()
            realmInstance.delete(oldGroups)
            realmInstance.add(groups)
            try realmInstance.commitWrite()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func removeObject(_ object: Object) {
        do {
            let realmInstance = try Realm()
            realmInstance.beginWrite()
            realmInstance.delete(object)
            try realmInstance.commitWrite()
        } catch {
            print("removeObject error:\(error)")
        }
    }
    
    func addObject(_ object: Object) {
        do {
            let realmInstance = try Realm()
            realmInstance.beginWrite()
            realmInstance.add(object)
            try realmInstance.commitWrite()
        } catch {
            print("addObject error:\(error)")
        }
    }
}
