//
//  TMProductRecordManagedObject.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/24/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import Foundation
import CoreData

class TMProductRecordManagedObject: NSManagedObject {

    @NSManaged var product_id: String
    @NSManaged var product_name: String
    @NSManaged var price: NSNumber
    @NSManaged var quantity: NSNumber
    @NSManaged var actual_amount: NSNumber
    @NSManaged var restingOrder: TMRestingOrderManagedObject

}
