//
//  TMTakeOrder.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/17/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import Foundation

// MARK: - 枚举定义

/**
支付方式

- Cash:           现金支付
- Balance:        余额支付
- CashAndBalance: 现金+余额
- IBoxPay:        盒子支付
- Other:          其他支付
*/
enum TMTransactionMode: Int {
    case Cash = 1
    case Balance = 2
    case CashAndBalance = 3
    case IBoxPay = 4
    case Other = 9
}

/**
折扣类型

折扣组合类型，中间以","分隔，比如:"1,3"，那么就可以同时享受签到优惠以及余额优惠
- Sign:     签到奖励
- Consume:  消费奖励
- Balance:  余额奖励
*/
enum TMDiscountType: Int {
    case Sign = 1
    case Consume = 2
    case Balance = 3
}

/**
消费奖励生效规则

- Now:      T+0,即时生效
- Next: T+1,下次生效
*/
enum TMImmediateType: Int {
    case Now
    case Next
}


/**
折扣组合模式

- Union:  组合模式
- Single: 非组合模式
*/
enum TMCombinationMode: Int {
    case Union
    case Single
}

/**
计算规则

- None:    无商品的计算
- Default: 有商品的计算
*/
enum TMRuleType: Int {
    case None
    case Default
}

// MARK: - 点单数据结构

struct TMTakeOrder {
    
    // 订单列表
    lazy var list = [TMProduct]()
    
    // 用户余额
    var balanceAmount: Double = 0.0
    
    // 消费总额
    var consumeAmount: Double = 0.0
    
    // 交易方式
    var transactionMode: TMTransactionMode?
    
    // 当前折扣类型
    var currentDiscountType: TMDiscountType?
    
    // 当前折扣
    var currentDiscount: Double = 1.0
    
    /**
    计算未打折的总金额
    
    :returns: 消费金额
    */
    mutating func calculateTotalConsumeAmount() -> Double {
        var total: Double = 0.0
        
        for product in list {
            var quantity = product.quantity.doubleValue
            var quotation = product.official_quotation.doubleValue
            total += quantity * quotation
        }
        
        return total
    }
    
    /**
    获取已输入金额的折后金额
    
    :returns: 折后金额
    */
    mutating func calculateDiscountConsumeAmount() -> Double {
        return consumeAmount * currentDiscount
    }
}

// MARK: - 点单规则
struct TMTakeOrderRule {
    
    // 消费奖励计算规则
    var immediate: TMImmediateType = .Now
    
    // 折扣组合模式
    var combinationMode: TMCombinationMode = .Single
    
    // 默认到访折扣，1.0不打折
    var signDiscount: Double = 1.0
    
    // 默认消费折扣，1.0不打折
    var consumeDiscount: Double = 1.0
    
    // 商品规则类型
    var ruleType: TMRuleType = .Default
}


// MARK: - 点单算法

struct TMTakeOrderCompute {
    
    // 点单数据结构
    lazy var takeOrder = TMTakeOrder()
    
    
    /**
    添加商品
    
    :param: product 待添加商品
    
    :returns: 添加状态
    */
    mutating func addProduct(product: TMProduct) -> Bool {

        if takeOrder.list.count == 0 {
            product.quantity = 1
            takeOrder.list.append(product)
        } else {
            // 查找是否已有此商品，如果有，那么+1
            var find = false
            
            for data in takeOrder.list {
                if data.product_id == product.product_id {
                    find = true
                    var quantity = data.quantity.integerValue + 1
                    data.quantity = NSNumber(integer: quantity)
                    break
                }
                
                if !find {
                    product.quantity = 1
                    takeOrder.list.append(product)
                }
            }
        }
        
        // 刷新数据
        
        return true
    }
    
    /**
    减少商品数量
    
    :param: product 待减商品
    
    :returns: 是否操作成功
    */
    mutating func subtractProduct(product: TMProduct) -> Bool {
        
        var success = false
        
        for var index = 0; index < takeOrder.list.count; ++index {
            var data = takeOrder.list[index]
            
            if data.product_id == product.product_id {
                success = true
                
                var quantity = data.quantity.integerValue - 1
                
                if quantity <= 0 {
                    takeOrder.list.removeAtIndex(index)
                    break
                } else {
                    data.quantity = NSNumber(integer: quantity)
                }
            }
        }
        
        // 刷新数据
        
        return success
    }
    
    
    /**
    删除商品
    
    :param: product 待删除商品
    
    :returns: 操作状态
    */
    mutating func deleteProduct(product: TMProduct) -> Bool {
        var success = false
        
        for var index = 0; index < takeOrder.list.count; ++index {
            var data = takeOrder.list[index]
            
            if data.product_id == product.product_id {
                success = true
                
                // 状态置为0
                data.quantity = 0
                takeOrder.list.removeAtIndex(index)
                break
            }
        }
        
        // 刷新数据
        
        return success
    }
    
    
}