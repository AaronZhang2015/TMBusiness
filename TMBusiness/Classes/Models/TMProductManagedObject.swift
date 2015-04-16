//
//  TMProductManagedObject.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/16/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import Foundation
import CoreData

class TMProductManagedObject: NSManagedObject {

    @NSManaged var aTemplate_examples_plate: String
    @NSManaged var category_id: String
    @NSManaged var category_name: String
    @NSManaged var description_1: String
    @NSManaged var description_2: String
    @NSManaged var description_3: String
    @NSManaged var description_4: String
    @NSManaged var description_5: String
    @NSManaged var discount_type: String
    @NSManaged var height: NSNumber
    @NSManaged var image_url: String
    @NSManaged var is_discount: NSNumber
    @NSManaged var monetary_unit: String
    @NSManaged var official_quotation: NSNumber
    @NSManaged var product_description: String
    @NSManaged var product_id: String
    @NSManaged var product_name: String
    @NSManaged var title_1: String
    @NSManaged var title_2: String
    @NSManaged var title_3: String
    @NSManaged var title_4: String
    @NSManaged var title_5: String
    @NSManaged var width: NSNumber
    @NSManaged var category: TMCategoryManagedObject

}
