//
//  TMCacheDataManager.swift
//  TMBusiness
//
//  Created by ZhangMing on 5/12/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import CoreData

class TMCacheDataManager: TMDataManager {
    
    lazy var cacheService: TMCacheService = {
        var service = TMCacheService()
        return service
        }()
    
    func fetchCacheInfo(cacheType: TMCacheType, adminId: String, completion: (String?) -> Void) {
//        cacheService.fetchCacheInfo(cacheType, adminId: adminId) { [weak self] (cacheId) -> Void in
//            
//            if let strongSelf = self {
//                if let cacheId = cacheId {
//                    strongSelf.cacheLocalCacheInfo(cacheType, cacheId: cacheId)
//                }
//                
//                completion(cacheId)
//            }
//        }
        
        cacheService.fetchCacheInfo(cacheType, adminId: adminId, completion: completion)
    }
    
    
    func cacheLocalCacheInfo(cacheType: TMCacheType, cacheId: String) {
        var context = CoreDataStack.sharedInstance.context
        let cacheEntity = NSEntityDescription.entityForName("TMCacheManagedObject",
            inManagedObjectContext: context)
        let cacheFetchRequest = NSFetchRequest(entityName: "TMCacheManagedObject")
        var predicate = NSPredicate(format: "table_name == %@", cacheType.rawValue)
        cacheFetchRequest.predicate = predicate
        var error: NSError?
        let result = context.executeFetchRequest(cacheFetchRequest, error: &error) as? [TMCacheManagedObject]
        if let list = result {
            for record in list {
                context.deleteObject(record)
            }
        }
        
        let cache = TMCacheManagedObject(entity: cacheEntity!,
            insertIntoManagedObjectContext: context)
        cache.cache_id = cacheId
        cache.table_name = cacheType.rawValue
        //Save the managed object context
        if !context.save(&error) {
            println("Could not save: \(error)")
        }
    }
    
    func fetchLocalCacheInfo(cacheType: TMCacheType) -> String? {
        var context = CoreDataStack.sharedInstance.context
        let cacheFetchRequest = NSFetchRequest(entityName: "TMCacheManagedObject")
        var predicate = NSPredicate(format: "table_name == %@", cacheType.rawValue)
        cacheFetchRequest.predicate = predicate
        
        var error: NSError?
        let result = context.executeFetchRequest(cacheFetchRequest, error: &error) as? [TMCacheManagedObject]
        
        var cacheId: String?
        
        if let list = result {
            if list.count > 0 {
                var record = list[0]
                cacheId = record.cache_id
            }
        }
        
        return cacheId
    }
}
