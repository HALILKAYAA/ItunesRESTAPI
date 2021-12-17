//
//  DataService.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import UIKit
import CoreData


/// Data Service Operator Class
class DataService: NSObject {

    private static var _instance : DataService?
    public static var sharedInstance : DataService {
        if let instance = DataService._instance {
            return instance
        }
        DataService._instance = DataService()
        return _instance!
    }
    private override init() {
        super.init()
    }
    
    /// Checks if entity exists on the database with given id.
    /// - Parameter mediaId: The id of the media
    /// - Returns: Found object on the database or nil if not found.
    private func getIsMediaSettingExists(mediaId: Int) ->NSManagedObject? {
        guard let managedContext = DataUtil.sharedInstance.getManagedObjectContext() else {
            print("Can't create or get ManagedContext")
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Data.MediaSetting.name)
        fetchRequest.predicate = NSPredicate(format: "\(Constants.Data.MediaSetting.key_id) == %d", mediaId)
        
        
        do {
            let fetchResults = try managedContext.fetch(fetchRequest)
            
            for item in fetchResults as! [NSManagedObject]{
                return item
            }
        } catch let error{
            print(error.localizedDescription)
            return nil
        }
        return nil
    }
    
    /// Adds item to database with given values
    /// - Parameters:
    ///   - mediaId: Id of the media
    ///   - isRead: Read status
    ///   - isDeleted: Delete status
    private func addMediaSetting(mediaId : Int, isRead : Bool = false, isDeleted : Bool = false) {
        
        guard let managedContext = DataUtil.sharedInstance.getManagedObjectContext() else {
            return
        }
        
        guard let item = DataUtil.sharedInstance.getManagedObjectItem(entityName: Constants.Data.MediaSetting.name) else {
            return
        }
        
        item.setValue(isRead, forKey: Constants.Data.MediaSetting.key_isRead)
        item.setValue(isDeleted, forKey: Constants.Data.MediaSetting.key_isDeleted)
        item.setValue(mediaId, forKey: Constants.Data.MediaSetting.key_id)
        
        do{
            try managedContext.save()
        } catch let error{
            print("Data Error: \(error.localizedDescription)")
        }
    }
    
    /// Marks a field as read.
    /// - Parameter mediaId: Id of the media
    func markMediaRead(mediaId : Int) {
        guard let managedContext = DataUtil.sharedInstance.getManagedObjectContext() else {
            return
        }
        
        guard let item = DataService.sharedInstance.getIsMediaSettingExists(mediaId: mediaId) else {
            addMediaSetting(mediaId: mediaId, isRead: true, isDeleted: false)
            return
        }
        
        item.setValue(true, forKey: Constants.Data.MediaSetting.key_isRead)
        
        do{
            try managedContext.save()
        } catch let error{
            print("Data Error: \(error.localizedDescription)")
        }
    }
    
    /// Marks a field as deleted
    /// - Parameter mediaId: Id of the media
    func markMediaDeleted(mediaId : Int) {
        guard let managedContext = DataUtil.sharedInstance.getManagedObjectContext() else {
            return
        }
        
        guard let item = DataService.sharedInstance.getIsMediaSettingExists(mediaId: mediaId) else {
            addMediaSetting(mediaId: mediaId, isRead: false, isDeleted: true)
            return
        }
        
        item.setValue(true, forKey: Constants.Data.MediaSetting.key_isDeleted)
        
        do{
            try managedContext.save()
        } catch let error{
            print("Data Error: \(error.localizedDescription)")
        }
    }
    
    /// Checks if entity is deleted
    /// - Parameter mediaId: Id of media.
    /// - Returns: Whether it is deleted or not.
    func getIsEntityDeleted(mediaId: Int) -> Bool {
        guard let item = self.getIsMediaSettingExists(mediaId: mediaId) else {
            return false
        }
        return item.value(forKey: Constants.Data.MediaSetting.key_isDeleted) as! Bool
    }
    
    /// Checks if entity is read or not
    /// - Parameter mediaId: Id of media
    /// - Returns: Whether it is read or not.
    func getIsMediaRead(mediaId : Int) -> Bool {
        guard let item = self.getIsMediaSettingExists(mediaId: mediaId) else {
            return false
        }
        return item.value(forKey: Constants.Data.MediaSetting.key_isRead) as! Bool
    }
    
}
