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

- Now:  T+0,即时生效
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
    
    // 点单数据规则
    lazy var takeOrderRule = TMTakeOrderRule()
    
    // 用户实体信息
    var user: TMUser!
    
    var shop: TMShop!
    
    mutating func getProducts() -> [TMProduct] {
        return takeOrder.list
    }
    
    /**
    添加商品
    
    :param: product 待添加商品
    
    :returns: 索引
    */
    mutating func addProduct(product: TMProduct) -> Int {
        var index = 0
        if takeOrder.list.count == 0 {
            product.quantity = 1
            takeOrder.list.append(product)
            index = takeOrder.list.count - 1
        } else {
            // 查找是否已有此商品，如果有，那么+1
            var find = false
            
            for index = 0; index < takeOrder.list.count; ++index {
                var data = takeOrder.list[index]
                if data.product_id == product.product_id {
                    find = true
                    var quantity = data.quantity.integerValue + 1
                    data.quantity = NSNumber(integer: quantity)
                    break
                }
            }
            
            if !find {
                product.quantity = 1
                takeOrder.list.append(product)
                index = takeOrder.list.count - 1
            }
        }
        
        // 刷新数据
        
        return index
    }
    
    /**
    减少商品数量
    
    :param: product 待减商品
    
    :returns: 是否操作成功
    */
    mutating func subtractProduct(product: TMProduct) -> (Bool, Int) {
        
        var success = false
        var returnIndex = 0
        
        for var index = 0; index < takeOrder.list.count; ++index {
            var data = takeOrder.list[index]
            
            if data.product_id == product.product_id {
                success = true
                
                var quantity = data.quantity.integerValue - 1
                if quantity <= 0 {
                    takeOrder.list.removeAtIndex(index)
                    returnIndex = -1
                } else {
                    data.quantity = NSNumber(integer: quantity)
                    returnIndex = index
                }
                break
            }
        }
        
        // 刷新数据
        
        return (success, returnIndex)
    }
    
    
    /**
    删除商品
    
    :param: product 待删除商品
    
    :returns: 操作状态
    */
    mutating func deleteProduct(product: TMProduct) -> (Bool, Int) {
        var success = false
        var returnIndex = 0
        for var index = 0; index < takeOrder.list.count; ++index {
            var data = takeOrder.list[index]
            
            if data.product_id == product.product_id {
                success = true
                
                // 状态置为0
                data.quantity = 0
                takeOrder.list.removeAtIndex(index)
                returnIndex = index
                break
            }
        }
        
        // 刷新数据
        
        return (success, returnIndex)
    }
    
    /**
    获取商品的总金额
    
    根据是否有商品来计算
    :returns: 商品的总金额
    */
    mutating func getConsumeAmount() -> Double {
        var amount = 0.0
        // 如果是有商品的计算
        if takeOrderRule.ruleType == TMRuleType.Default {
            amount = takeOrder.calculateTotalConsumeAmount()
        } else {
            // 无商品的计算
            amount = takeOrder.consumeAmount
        }
        
        return amount
    }
    
    /**
    获取最大折扣率
    
    :returns: 折扣率
    */
    mutating func getMaxDiscount() -> Double {
        if takeOrderRule.consumeDiscount <= takeOrderRule.signDiscount {
            return takeOrderRule.consumeDiscount
        }
        
        return takeOrderRule.signDiscount
    }
    
    /**
    返回折后应付金额
    
    根据有无商品来分别计算
    *有商品：根据每个商品是否参与打折来计算 = 应付金额
    *无商品：根据商家输入的订单总额 * 当前选择的折扣= 应付金额
    :returns: 实际支付金额
    */
    mutating func calculateActualAmount() -> Double {
        var actualAmount = 0.0
        if takeOrderRule.ruleType == .Default {
            return takeOrder.calculateDiscountConsumeAmount()
        }
        
        return takeOrder.consumeAmount * takeOrder.currentDiscount
    }
    
    // MARK: - 配置规则和算法
    
    mutating func setRuleDetail(shop: TMShop, hasProduct: Bool) {
        self.shop = shop
        
        // 组合模式
        var combination = shop.combination as NSString
        if combination.length > 0 {
            if combination.containsString("\(TMDiscountType.Balance.rawValue)") && (combination.containsString("\(TMDiscountType.Sign.rawValue)") || combination.containsString("\(TMDiscountType.Consume.rawValue)")) {
                // 可用组合支付模式：余额支付 加（签到奖励或消费折扣）
                takeOrderRule.combinationMode = TMCombinationMode.Union
            } else {
                // 不可组合模式
                takeOrderRule.combinationMode = TMCombinationMode.Single
            }
        }
        
        // 生效规则
        
        if let immediate = shop.immediate {
            // 当次生效奖励
            if (immediate as NSString).containsString("\(TMImmediateType.Now.rawValue)") {
                takeOrderRule.immediate = TMImmediateType.Now
            } else {
                takeOrderRule.immediate = TMImmediateType.Next
            }
        }
        
        // 根据是否有商品来计算
        if hasProduct {
            takeOrderRule.ruleType = TMRuleType.Default
        } else {
            takeOrderRule.ruleType = TMRuleType.None
        }
        
        // 刷新数据
    }
    
    /**
    设置用户，配置规则和算法
    
    设置用户，从中取出Shop，从而获得商家配置
    
    :param: user 用户信息以及shop信息
    :param: hasProducts 是否有商品计算规则
    */
    mutating func setUserDetail(user: TMUser, hasProducts: Bool) {
        self.user = user
        if let reward_record = user.reward_record {
            if reward_record.count > 0 {
                // 设置组合模式和生效模式
                setRuleDetail(reward_record[0].shop!, hasProduct: hasProducts)
                
                for reward in reward_record {
                    
                    // 签到奖励（折扣）
                    if let sign_reward_current = reward.sign_reward_current, type = reward.type {
                        if type.integerValue == TMDiscountType.Sign.rawValue {
                            // 解析并设置到访折扣率
                            takeOrderRule.signDiscount = sign_reward_current.doubleValue
                        }
                    }
                    
                    // 消费奖励
                    if let consume_reward_current = reward.consume_reward_current, type = reward.type {
                        if type.integerValue == TMDiscountType.Consume.rawValue {
                            // 解析并设置到访折扣率累计消费折扣
                            var consumeDiscout = getCurrentConsumeDiscount(reward_record)
                            takeOrderRule.consumeDiscount = consumeDiscout
                            
                            // 如果消费累计折扣大于当前的消费折扣，则消费累计折扣等于消费折扣
                            // 给予用户最大的折扣率
                        }
                    }
                }
            }
        }
        
        // 余额
        if let user_account_balance = user.user_account_balance {
            if user_account_balance.count > 0 {
                var balance = user_account_balance[0].amount.doubleValue
                takeOrder.balanceAmount = balance
            }
        }
        
        // 刷新数据
        // TODO
    }
    
    
    /**
    计算消费折扣
    
    根据T+0还是T+1返回消费金额折扣率
    
    :param: reward_records 奖励记录列表
    
    :returns: 实际消费折扣
    */
    mutating func getCurrentConsumeDiscount(reward_records: [TMRewardRecord]?) -> Double {
        var discount = 1.0
        
        if reward_records == nil || reward_records?.count == 0 {
            return discount
        }
        
        var consumeAmount = getConsumeAmount()
        
        for reward_record in reward_records! {
            // 消费奖励
            if let type = reward_record.type, shop = reward_record.shop, rewards = reward_record.shop!.rewards {
                if type.integerValue == TMDiscountType.Consume.rawValue {
                    if let consume_number_current = reward_record.consume_number_current {
                        // 计算当前的金额+历史消费总额，计算当前位于的消费区间，并返回正确的折扣
                        consumeAmount += consume_number_current.doubleValue
                    }
                    
                    // 遍历消费区间
                    for reward in rewards {
                        if let type = reward.type, current_number_min = reward.current_number_min, current_number_max = reward.current_number_max {
                            if type.integerValue == TMDiscountType.Consume.rawValue {
                                var minPrice = current_number_max.doubleValue
                                var maxPrice = current_number_max.doubleValue
                                
                                if maxPrice == -1 {
                                    maxPrice = DBL_MAX
                                }
                                
                                if let reward_description = reward.reward_description {
                                    if consumeAmount >= minPrice && consumeAmount <= maxPrice {
                                        discount = (reward_description as NSString).doubleValue / 10
                                        return discount
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return discount
    }
    
    func getUserMobilePhoneNumber() -> String {
        if user == nil {
            return ""
        }
        
        return user.mobile_number
    }
}