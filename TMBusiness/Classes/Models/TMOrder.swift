//
//  TMOrder.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 3/30/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit

/**
*  消费记录
*/
class TMOrder: NSObject {
   
    // 订单编号
    var order_id: String?
    
    // 终端用户编号
    var user_id: String?
    
    // 商铺编号
    var shop_id: String?
    
    // 交易方式（1：现金）
    var transaction_mode: NSNumber?
    
    // 登记方式（1：手动 2：自动）
    var register_type: NSNumber?
    
    // 应付金额
    var payable_amount: NSNumber?

    // 优惠券编号
    var coupon_id: NSNumber?
    
    // 折扣率
    var discount: NSNumber?
    
    // 折扣类型（1：签到）
    var discount_type: NSNumber?
    
    // 登记时间
    var register_time: NSNumber?
    
    // 状态
    var status: NSNumber?
    
    // 会员手机号码
    var user_mobile_number: String?
    
    // 描述
    var order_description: String?
    
    // 商品实体集合
    var product_records: [TMProductRecord]?
}


/*
order_id								订单编号
user_id								终端用户编号
shop_id								商铺编号
transaction_mode						交易方式（1：现金）
register_type							登记方式（1：手动 2：自动）
payable_amount						应付金额
actual_amount						实付金额
coupon_id							优惠券编号
discount								折扣率
discount_type							折扣类型（1：签到）
register_time							登记时间
status								状态
user_mobile_number					会员手机号码
description							描述
product_record						商品实体集合
*/