//
//  TMOrderProduct.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/4/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import Foundation

struct TMOrderProduct {
    
    // 商品编号
    var product_id: String!
    
    // 商品名称
    var product_name: String!
    
    // 数量
    var quantity: NSNumber = 0
    
    // 单价
    var price: NSNumber = 0
}