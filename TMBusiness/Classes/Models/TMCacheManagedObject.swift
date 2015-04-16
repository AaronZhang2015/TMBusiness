//
//  TMCacheManagedObject.swift
//  
//
//  Created by ZhangMing on 4/16/15.
//
//

import Foundation
import CoreData

class TMCacheManagedObject: NSManagedObject {

    @NSManaged var cache_id: String
    @NSManaged var table_name: String

}
