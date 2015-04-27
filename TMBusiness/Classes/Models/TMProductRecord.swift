//
//  TMProductRecord.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 3/30/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit

/**
*  商品销售记录信息实体模型
*/
class TMProductRecord: NSObject {
    
    // 商品编号
    var product_id: String?
    
    // 商品名称
    var product_name: String?
    
    // 商品单价
    var price: NSNumber! = 0
    
    // 数量
    var quantity: NSNumber! = 0
    
    // 实付金额
    var actual_amount: NSNumber! = 0
    
    // 总额
    var total_amount: NSNumber = 0
}


/*
product_id							商品编号
product_name							商品名称
price								商品单价
quantity								数量
actual_amount						实付金额
*/