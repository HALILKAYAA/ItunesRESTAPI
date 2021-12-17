//
//  DataUtil.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import UIKit
import CoreData

/// Core Data Utility Class
class DataUtil: NSObject {
    
    private static var _instance : DataUtil?
    
    public static var sharedInstance : DataUtil {
        if let instance = DataUtil._instance {
            return instance
        }
        DataUtil._instance = DataUtil()
        return _instance!
    }
    
    private override init() {
        super.init()
    }
    private static var managedContext : NSManagedObjectContext?
    
    
    
    /// This function generates or gets context for CoreData single instance
    /// - Returns: Core Data Context
    public func getManagedObjectContext () -> NSManagedObjectContext? {
        if let managedContext = DataUtil.self.managedContext {
            return managedContext
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        DataUtil.managedContext = appDelegate.persistentContainer.viewContext
        return DataUtil.managedContext
    }
    
    
    /// Get Object for given type for Core Data
    /// - Parameter entityName: the name representation of database item
    /// - Returns: Database Object
    public func getManagedObjectItem(entityName : String) -> NSManagedObject? {
        
        guard let managedContext = self.getManagedObjectContext() else {
            return nil
        }
        
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)
        return NSManagedObject(entity: entity!, insertInto: managedContext)
        
    }
}
