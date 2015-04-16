//
//  TMCategoryManagedObject.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/16/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import Foundation
import CoreData

class TMCategoryManagedObject: NSManagedObject {

    @NSManaged var category_id: String
    @NSManaged var category_name: String
    @NSManaged var category_pid: String
    @NSManaged var discount_type: String
    @NSManaged var is_discount: NSNumber
    @NSManaged var products: NSOrderedSet

}
