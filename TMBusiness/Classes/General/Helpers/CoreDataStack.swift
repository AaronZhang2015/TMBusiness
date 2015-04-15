//
//  CoreDataStack.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/15/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack {
    let context: NSManagedObjectContext
    let psc: NSPersistentStoreCoordinator
    let model: NSManagedObjectModel
    let store: NSPersistentStore?
    
    init() {
        let bundle = NSBundle.mainBundle()
        let modelURL = bundle.URLForResource("Thing Me", withExtension: "momd")
        model = NSManagedObjectModel(contentsOfURL: modelURL!)!
        
        
        psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        context = NSManagedObjectContext()
        context.persistentStoreCoordinator = psc
        
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as! [NSURL]
        let documentsURL = urls[0]
        
        let storeURL = documentsURL.URLByAppendingPathComponent("Thing Me")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true]
        
        var error: NSError? = nil
        store = psc.addPersistentStoreWithType(NSSQLiteStoreType,
            configuration: nil,
            URL: storeURL,
            options: options,
            error:&error)
        
        if store == nil {
            println("Error adding persistent store: \(error)")
            abort()
        }
    }
    
    class var sharedInstance: CoreDataStack {
        struct Singleton {
            static let instance = CoreDataStack()
        }
        return Singleton.instance
    }
    
    func saveContext() {
        var error: NSError? = nil
        if context.hasChanges && !context.save(&error) {
            println("Could not save: \(error), \(error?.userInfo)")
        }
    }
    
    func applicationDocumentsDirectory() -> NSURL {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as! [NSURL]
        return urls[0]
    }
    
    
}
