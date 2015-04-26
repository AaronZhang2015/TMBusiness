//
//  TMOrderDataManager.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/24/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import CoreData

class TMOrderDataManager: TMDataManager {
    
    lazy var orderService: TMOrderService = {
        return TMOrderService()
        }()
    
    
    /**
    添加订单
    
    :param: userId          用户编号
    :param: shopId          商铺编号
    :param: transactionMode 交易方式
    :param: registerType    注册类型
    :param: payableAmount   应付金额
    :param: actualAmount    实际支付金额
    :param: couponId        优惠券编号
    :param: discount        折扣率
    :param: discountType    折扣类型
    :param: description     备注
    :param: businessId      商户编号
    :param: orderStatus     订单状态
    :param: productList     订单商品列表
    :param: adminId         管理面比那好
    :param: completion      回调
    */
    
    /**
    添加订单
    
    :param: order      订单
    :param: completion 回调
    */
    func addOrderEntityInfo(order: TMOrder, completion:(String?, NSError?) -> Void) {
        
        if let user_id = order.user_id, shop_id = order.shop_id {
            let format = ".2"
            var couponId = ""
            if let conpon_id = order.coupon_id {
                couponId = conpon_id
            }
            
            var discountString = ""
            if let discount = order.discount {
                discountString = "\(discount.doubleValue.format(format))"
            }
            
            var businessId = ""
            if let business_id = order.business_id {
                businessId = business_id
            }
            
            var adminId = ""
            if let admin_id = order.admin_id {
                adminId = admin_id
            }
            
            orderService.addOrderEntityInfo(userId: user_id, shopId: shop_id, transactionMode: order.transaction_mode, registerType: order.register_type, payableAmount: order.payable_amount, actualAmount: order.actual_amount, couponId: couponId, discount: discountString, discountType: order.discount_type, description: order.order_description!, businessId: businessId, orderStatus: order.status, productList: order.product_records, adminId: adminId, completion: completion)
        }
    }
    
    
    /**
    挂单
    
    :param: order 待挂订单
    */
    func cacheRestingOrder(order: TMOrder) {
        var managedContext = CoreDataStack.sharedInstance.context
        let restingOrderEntity = NSEntityDescription.entityForName("TMRestingOrderManagedObject",
            inManagedObjectContext: managedContext)
        let productRecordEntity = NSEntityDescription.entityForName("TMProductRecordManagedObject",
            inManagedObjectContext: managedContext)
        
        let restingOrder = TMRestingOrderManagedObject(entity: restingOrderEntity!,
            insertIntoManagedObjectContext: managedContext)
        
        if let user_id = order.user_id{
            restingOrder.user_id = user_id
        }
        if let order_id = order.order_id {
            restingOrder.order_id = order_id
        }
        
        if let order_index = order.order_index{
            restingOrder.order_index = order_index
        }
        
        if let shop_id = order.shop_id {
            restingOrder.shop_id = shop_id
        }
        
        if let business_id = order.business_id{
            restingOrder.business_id = business_id
        }
        
        if let admin_id = order.admin_id {
            restingOrder.admin_id = admin_id
        }
        
        restingOrder.transaction_mode = NSNumber(integer: order.transaction_mode.rawValue)
        
        restingOrder.register_type = NSNumber(integer: order.register_type.rawValue)
        
        restingOrder.payable_amount = order.payable_amount
        restingOrder.actual_amount = order.actual_amount
        
        if let coupon_id = order.coupon_id {
            restingOrder.coupon_id = coupon_id
        }
        
        if let discount = order.discount{
            restingOrder.discount = discount
        }
        
        restingOrder.discount_type = NSNumber(integer: order.discount_type.rawValue)
        
        if let register_time = order.register_time {
            restingOrder.register_time = register_time
        }
        
        restingOrder.status = NSNumber(integer: order.status.rawValue)
        
        if let user_mobile_number = order.user_mobile_number {
            restingOrder.user_mobile_number = user_mobile_number
        }
        
        if let order_description = order.order_description {
            restingOrder.order_description = order_description
        }
        
        var productRecords = NSMutableOrderedSet()//[TMProductRecordManagedObject]()
        // product records
        for productRecord in order.product_records {
            var record = TMProductRecordManagedObject(entity: productRecordEntity!,
                insertIntoManagedObjectContext: managedContext)
            if let product_id = productRecord.product_id {
                record.product_id = product_id
            }
            
            if let product_name = productRecord.product_name {
                record.product_name = product_name
            }
            
            record.price = productRecord.price
            record.quantity = productRecord.quantity
            record.actual_amount = productRecord.actual_amount
            productRecords.addObject(record)
        }
        
        restingOrder.product_records = productRecords
        
        //Save the managed object context
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
        }
    }
    
}
