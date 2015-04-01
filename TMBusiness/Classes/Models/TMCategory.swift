//
//  TMCategory.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 3/30/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit

/**
*  商品类别实体模型
*/
class TMCategory: NSObject {
    
    // 商品类别编号
    var category_id: String?
    
    // 商品类别父级编号
    var category_pid: String?
    
    // 商品类别名称
    var category_name: String?
    
    // 是否参与打折（0：不参与任何打折类型  1：参与全部打折类型  2：参与部分打折类型）
    var is_discount: NSNumber?
    
    // 折扣/打折类型
    var discount_type: String?
    
    // 商品实体模型集
    var products: [TMProduct]?
}

/*
category_id							商品类别编号
category_pid							商品类别父级编号
category_name						商品类别名称
is_discount							是否参与打折（0：不参与任何打折类型  1：参与										全部打折类型  2：参与部分打折类型）
discount_type							折扣/打折类型
products								商品实体模型集
*/
