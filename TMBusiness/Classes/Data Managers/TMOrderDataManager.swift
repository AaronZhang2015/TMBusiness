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
    
    
    func fetchOrderEntityList(shopId: String, type: TMOrderStatus, pageIndex: Int, pageSize: Int = 10, adminId: String, completion: ([TMOrder]?, NSError?) -> Void) {
        orderService.fetchOrderEntityList(shopId, type: type, pageIndex: "\(pageIndex)", pageSize: "\(pageSize)", adminId: adminId, completion: completion)
    }
    
    
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
        
        let format = ".2"
        var couponId = ""
        if let conpon_id = order.coupon_id {
            couponId = conpon_id
        }
        
        var discountString = ""
        if let discount = order.discount {
            var discountRate = discount.doubleValue //* 10
            discountString = "\(discountRate.format(format))"
        }
        
        var businessId = ""
        if let business_id = order.business_id {
            businessId = business_id
        }
        
        var adminId = ""
        if let admin_id = order.admin_id {
            adminId = admin_id
        }
        
        var userId = ""
        if let user_id = order.user_id {
            userId = user_id
        }
        
        
        orderService.addOrderEntityInfo(userId: userId, shopId: order.shop_id!, transactionMode: order.transaction_mode, registerType: order.register_type, payableAmount: order.payable_amount, actualAmount: order.actual_amount, couponId: couponId, discount: discountString, discountType: order.discount_type, description: order.order_description!, businessId: businessId, orderStatus: order.status, productList: order.product_records, adminId: adminId, completion: completion)
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
        
        var productRecords = NSMutableOrderedSet()
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
    
    /**
    删除挂单
    
    :param: order 待删除挂单
    */
    func deleteRestingOrder(order: TMOrder) {
        var context = CoreDataStack.sharedInstance.context
        
        var managedContext = CoreDataStack.sharedInstance.context
        let restingOrderFetch = NSFetchRequest(entityName: "TMRestingOrderManagedObject")
        var predicate = NSPredicate(format: "order_index == %@", order.order_index!)
        restingOrderFetch.predicate = predicate
        var error: NSError?
        let result = managedContext.executeFetchRequest(restingOrderFetch, error: &error) as?[TMRestingOrderManagedObject]
        
        if let list = result {
            if list.count > 0 {
                managedContext.deleteObject(list[0])
                
                for product in list[0].product_records {
                    managedContext.deleteObject(product as! TMProductRecordManagedObject)
                }
            }
            
        }
        
        //Save the managed object context
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
        }
    }
    
    /// 清空挂单
    func clearRestingOrder() {
        var context = CoreDataStack.sharedInstance.context
        let restingOrderFetch = NSFetchRequest(entityName: "TMRestingOrderManagedObject")
        var error: NSError?
        let result = context.executeFetchRequest(restingOrderFetch, error: &error) as! [TMRestingOrderManagedObject]
        
        for restingOrder in result {
            context.deleteObject(restingOrder)
            
            for product in restingOrder.product_records {
                context.deleteObject(product as! TMProductRecordManagedObject)
            }
        }
        
        //Save the managed object context
        if !context.save(&error) {
            println("Could not save: \(error)")
        }
    }
    
    /**
    获取挂单列表
    
    :returns: 挂单列表
    */
    func fetchRestingOrderList() -> [TMOrder] {
        var restingOrderList = [TMOrder]()
        
        var context = CoreDataStack.sharedInstance.context
        let restingOrderFetch = NSFetchRequest(entityName: "TMRestingOrderManagedObject")
        var registerTimeDescriptor = NSSortDescriptor(key: "register_time", ascending: false)
        restingOrderFetch.sortDescriptors = [registerTimeDescriptor]
        
        var error: NSError?
        let result = context.executeFetchRequest(restingOrderFetch, error: &error) as! [TMRestingOrderManagedObject]
    
        for var i = 0; i < result.count; ++i {
            var restingOrderRecord = result[i]
            var order = TMOrder()
            
            // 赋值
            
            order.order_index = restingOrderRecord.order_index
            order.order_id = restingOrderRecord.order_id
            order.user_id = restingOrderRecord.user_id
            order.shop_id = restingOrderRecord.shop_id
            order.business_id = restingOrderRecord.business_id
            order.admin_id = restingOrderRecord.admin_id
            
            
            if let mode = TMTransactionMode(rawValue: restingOrderRecord.transaction_mode.integerValue) {
                order.transaction_mode = mode
            }
            
            if let type = TMRegisterType(rawValue: restingOrderRecord.register_type.integerValue) {
                order.register_type = type
            }
            
            order.payable_amount = restingOrderRecord.payable_amount
            order.actual_amount = restingOrderRecord.actual_amount
            order.coupon_id = restingOrderRecord.coupon_id
            order.discount = restingOrderRecord.discount
            
            if let type = TMDiscountType(rawValue: restingOrderRecord.discount_type.integerValue) {
                order.discount_type = type
            }
            
            order.register_time = restingOrderRecord.register_time

            if let status = TMOrderStatus(rawValue: restingOrderRecord.status.integerValue) {
                order.status = status
            } else {
                order.status = .Resting
            }
            
            order.user_mobile_number = restingOrderRecord.user_mobile_number
            order.order_description = restingOrderRecord.order_description
            
            var productRecordList = restingOrderRecord.product_records.array as! [TMProductRecordManagedObject]
            var productRecords = [TMProductRecord]()
            
            for var m = 0; m < productRecordList.count; ++m {
                var productRecordManagedObject = productRecordList[m]
                var productRecord = TMProductRecord()
                productRecord.product_id = productRecordManagedObject.product_id
                productRecord.product_name = productRecordManagedObject.product_name
                productRecord.price = productRecordManagedObject.price
                productRecord.quantity = productRecordManagedObject.quantity
                productRecord.actual_amount = productRecordManagedObject.actual_amount
                productRecords.append(productRecord)
            }
            
            order.product_records = productRecords
            restingOrderList.append(order)
        }
        
        return restingOrderList
    }
    
    func updateOrderStatus(order: TMOrder, completion: (Bool -> Void)) {
        orderService.updateOrderStatus(order.status, orderId: order.order_id!, shopId: order.shop_id!, businessId: order.business_id!, adminId: order.admin_id!, completion: completion)
    }
    
    
    func updateOrderEntityInfo(order: TMOrder, completion:(String?, NSError?) -> Void) {
        let format = ".2"
        
        var orderId = ""
        if let order_id = order.order_id {
            orderId = order_id
        }
        
        var couponId = ""
        if let conpon_id = order.coupon_id {
            couponId = conpon_id
        }
        
        var discountString = ""
        if let discount = order.discount {
            var discountRate = discount.doubleValue //* 10
            discountString = "\(discountRate.format(format))"
        }
        
        var businessId = ""
        if let business_id = order.business_id {
            businessId = business_id
        }
        
        var adminId = ""
        if let admin_id = order.admin_id {
            adminId = admin_id
        }
        
        var userId = ""
        if let user_id = order.user_id {
            userId = user_id
        }
        
        orderService.updateOrderEntityInfo(orderId: orderId, userId: userId, shopId: order.shop_id!, transactionMode: order.transaction_mode, registerType: order.register_type, payableAmount: order.payable_amount, actualAmount: order.actual_amount, couponId: couponId, discount: discountString, discountType: order.discount_type, description: order.order_description!, businessId: businessId, orderStatus: order.status, productList: order.product_records, adminId: adminId, completion: completion)
    }
    
    
    func fetchOrderIndex(shopId: String, completion:(NSError?, String?) -> Void) {
        orderService.fetchOrderIndex(shopId, completion: completion)
    }
}
