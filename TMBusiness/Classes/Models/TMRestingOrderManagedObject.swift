//
//  TMRestingOrderManagedObject.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/24/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import Foundation
import CoreData

class TMRestingOrderManagedObject: NSManagedObject {

    @NSManaged var order_index: String
    @NSManaged var order_id: String
    @NSManaged var user_id: String
    @NSManaged var shop_id: String
    @NSManaged var business_id: String
    @NSManaged var admin_id: String
    @NSManaged var transaction_mode: NSNumber
    @NSManaged var register_type: NSNumber
    @NSManaged var payable_amount: NSNumber
    @NSManaged var actual_amount: NSNumber
    @NSManaged var coupon_id: String
    @NSManaged var discount: NSNumber
    @NSManaged var discount_type: NSNumber
    @NSManaged var register_time: NSDate
    @NSManaged var status: NSNumber
    @NSManaged var user_mobile_number: String
    @NSManaged var order_description: String
    @NSManaged var product_records: NSOrderedSet

}
