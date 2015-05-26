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
奖励类型

- Sign:    签到
- Consume: 消费
- Recharge: 充值
*/
enum TMRewardType: Int {
    case Sign = 1
    case Consume = 2
    case Recharge = 3
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

class TMTakeOrder {
    
    // 订单列表
    lazy var list = [TMProduct]()
    
    // 用户余额
    var balanceAmount: Double = 0.0
    
    // 消费总额
    var consumeAmount: Double = 0.0
    
    // 交易方式
    var transactionMode: TMTransactionMode! = .Cash
    
    // 当前折扣类型
    var currentDiscountType: TMDiscountType! = .Sign
    
    // 当前折扣
    var currentDiscount: Double = 1.0
    
    // 当前最大折扣
    var maxDiscount: Double = 1.0
    
    /**
    计算未打折的总金额
    
    :returns: 消费金额
    */
    func calculateTotalConsumeAmount() -> Double {
        var total: Double = 0.0
        
        for product in list {
            var quantity = product.quantity.doubleValue
            var quotation = product.official_quotation.doubleValue
            total += quantity * quotation
        }
        
        return total
    }
    
    /**
    计算已选择商品的折后金额
    
    :returns: 折后金额
    */
    func calculateDiscountConsumeAmount() -> Double {
        var total: Double = 0.0
        
        for product in list {
            // 判断商品是否打折
            var productDiscount = 0.0
            
            if product.is_discount == nil || product.is_discount?.integerValue == 0 {
                productDiscount = 1.0
            } else {
                productDiscount = maxDiscount
            }
            
            // 价钱 * 折扣 * 数量
            
            var quantity = product.quantity.doubleValue
            var quotation = product.official_quotation.doubleValue
            total += quantity * quotation * productDiscount
        }
        
        return total
    }
    
    /**
    获取已输入金额的折后金额
    
    :returns: 折后金额
    */
    func calculateDiscountConsumeAmountForEdit() -> Double {
        return consumeAmount * currentDiscount
    }
    
    func clearAllData() {
        currentDiscount = 1.0
        maxDiscount = 1.0
        balanceAmount = 0.0
        consumeAmount = 0.0
        list.removeAll(keepCapacity: false)
        transactionMode = .Cash
    }
}

// MARK: - 点单规则
class TMTakeOrderRule {
    
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
    
    func clearAllData() {
        immediate = .Now
        combinationMode = .Single
        signDiscount = 1.0
        consumeDiscount = 1.0
        ruleType = .Default
    }
}


// MARK: - 点单算法

class TMTakeOrderCompute {
    
    // 点单数据结构
    lazy var takeOrder = TMTakeOrder()
    
    // 点单数据规则
    lazy var takeOrderRule = TMTakeOrderRule()
    
    var isWaitForPaying: Bool = false
    
    var isRestingOrder: Bool = false
    
    var isChangeOrder: Bool = false
    // 当前订单状态
//    var orderStatus: TMOrderStatus = .Resting
    
    
    var orderIndex: String?
    
    // 用户实体信息
    var user: TMUser?
    
    var shop: TMShop?
    
    // 备注
    var orderDescription: String = "" {
        didSet {
            if let closure = refreshDataClosure {
                closure(self)
            }
        }
    }
    
    // 刷新数据事件
    var refreshDataClosure: ((TMTakeOrderCompute) -> ())?
    
    // 清除事件
    var clearAllDataClosure: ((TMTakeOrderCompute) -> ())?
    
    func getProducts() -> [TMProduct] {
        return takeOrder.list
    }
    
    func setProducts(list: [TMProduct]) {
        takeOrder.list = list
    }
    
    /**
    添加商品
    
    :param: product 待添加商品
    
    :returns: 索引
    */
    func addProduct(product: TMProduct) -> Int {
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
        
        if let closure = refreshDataClosure {
            closure(self)
        }
        
        return index
    }
    
    /**
    减少商品数量
    
    :param: product 待减商品
    
    :returns: 是否操作成功
    */
    func subtractProduct(product: TMProduct) -> (Bool, Int) {
        
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
        if let closure = refreshDataClosure {
            closure(self)
        }
        
        return (success, returnIndex)
    }
    
    
    /**
    删除商品
    
    :param: product 待删除商品
    
    :returns: 操作状态
    */
    func deleteProduct(product: TMProduct) -> (Bool, Int) {
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
        if let closure = refreshDataClosure {
            closure(self)
        }
        
        return (success, returnIndex)
    }
    
    /**
    清空点单
    */
    func clearProductList() {
        for var index = takeOrder.list.count - 1; index >= 0; --index {
            var product = takeOrder.list[index]
            product.quantity = 0
        }
        
        takeOrder.list.removeAll(keepCapacity: false)
    }
    
    /**
    全部清空，置为初始状态
    */
    func clearAllData() {
        user = nil
        shop = nil
        takeOrder.clearAllData()
        takeOrderRule.clearAllData()
        clearProductList()
        isWaitForPaying = false
        isRestingOrder = false
        orderDescription = ""
        
        if let closure = clearAllDataClosure {
            closure(self)
        }
    }
    
    /**
    获取商品的总金额
    
    根据是否有商品来计算
    :returns: 商品的总金额
    */
    func getConsumeAmount() -> Double {
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
    func getMaxDiscount() -> Double {
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
    func getActualAmount() -> Double {
        var actualAmount = 0.0
        if takeOrderRule.ruleType == .Default {
            return takeOrder.calculateDiscountConsumeAmount()
        }
        
        return takeOrder.consumeAmount * takeOrder.currentDiscount
    }
    
    
    func getActualCashAmount() -> Double {
        var amount = getActualAmount() - getUserBalance().doubleValue
        let format = ".2"
        var string = amount.format(format)
        return string.doubleValue
    }
    
    // MARK: - 配置规则和算法
    
    func setRuleDetail(shop: TMShop, hasProduct: Bool) {
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
//            var typeString =  as NSString
            /*
            if (immediate as NSString).containsString("\(TMImmediateType.Now.rawValue)") {
                takeOrderRule.immediate = TMImmediateType.Now
            } else {
                takeOrderRule.immediate = TMImmediateType.Next
            }
*/
            
            var immediateString = immediate as NSString
            var typeString = "\(TMImmediateType.Now.rawValue)" as NSString
            
            var range = immediateString.rangeOfString("\(TMImmediateType.Now.rawValue)")
            
            if range.location != NSNotFound {
                takeOrderRule.immediate = TMImmediateType.Now
            } else {
                takeOrderRule.immediate = TMImmediateType.Next
            }
            
//            if immediateString.containsString("") {
//                takeOrderRule.immediate = TMImmediateType.Now
//            } else {
//                takeOrderRule.immediate = TMImmediateType.Next
//            }
        }
        
        // 根据是否有商品来计算
        if hasProduct {
            takeOrderRule.ruleType = TMRuleType.Default
        } else {
            takeOrderRule.ruleType = TMRuleType.None
        }
        
        // 刷新数据
        if let closure = refreshDataClosure {
            closure(self)
        }
    }
    
    /**
    设置用户，配置规则和算法
    
    设置用户，从中取出Shop，从而获得商家配置
    
    :param: user 用户信息以及shop信息
    :param: hasProducts 是否有商品计算规则
    */
    func setUserDetail(user: TMUser, hasProducts: Bool) {
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
        
        // 设置最大折扣
        takeOrder.maxDiscount = getMaxDiscount()
        
        // 余额
        if let user_account_balance = user.user_account_balance {
            if user_account_balance.count > 0 {
                var balance = user_account_balance[0].amount.doubleValue
                takeOrder.balanceAmount = balance
            }
        } else {
            takeOrder.balanceAmount = 0
        }
        
        // 刷新数据
        if let closure = refreshDataClosure {
            closure(self)
        }
    }
    
    
    /**
    计算消费折扣
    
    根据T+0还是T+1返回消费金额折扣率
    
    :param: reward_records 奖励记录列表
    
    :returns: 实际消费折扣
    */
    func getCurrentConsumeDiscount(reward_records: [TMRewardRecord]?) -> Double {
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
                                var minPrice = current_number_min.doubleValue
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
    
    // MARK: - 用户状态信息
    
    /**
    返回用户的手机号码
    
    :returns: 手机号码
    */
    func getUserMobilePhoneNumber() -> String {
        if let user = user {
            return user.mobile_number
        } else {
            return ""
        }
    }
    
    /**
    返回用户的昵称
    如果没有，那么返回手机号码
    
    :returns: 昵称
    */
    func getUserNickname() -> String {
        
        if let user = user {
            if user.nick_name == nil || count(user.nick_name!) == 0 {
                return user.mobile_number
            } else {
                return user.nick_name!
            }
        } else {
            return ""
        }
    }
    
    
    /**
    返回用户的余额
    
    :returns: 用户余额
    */
    func getUserBalance() -> NSNumber {
        
        if let user = user, user_account_balance = user.user_account_balance  {
            return user_account_balance[0].amount
        } else {
            return 0
        }
    }
    
    
    /**
    自动计算交易方式
    
    :returns: 交易方式
    */
    func getAutoTransactionMode() -> TMTransactionMode {
        if takeOrder.balanceAmount == 0.0 {
            takeOrder.transactionMode = TMTransactionMode.Cash
        } else if (takeOrder.balanceAmount - getActualAmount()) >= 0.0 {
            takeOrder.transactionMode = TMTransactionMode.Balance
        } else {
            takeOrder.transactionMode = TMTransactionMode.CashAndBalance
        }
        
        return takeOrder.transactionMode!
    }
    
    
    /**
    获取交易方式
    
    :returns: 交易方式
    */
    func getTransactionMode() -> TMTransactionMode {
        return takeOrder.transactionMode!
    }
    
    /**
    设置交易方式
    
    :param: transactionMode 交易方式
    */
    func setTransactionMode(transactionMode: TMTransactionMode) {
        takeOrder.transactionMode = transactionMode
    }
    
    /**
    获取折扣类型
    
    :returns: 折扣类型
    */
    func getDiscountType() -> TMDiscountType {
        return takeOrder.currentDiscountType
    }
    
    
    /**
    获取订单商品记录
    
    :returns: 订单商品记录
    */
    func getProductRecords() -> [TMProductRecord] {
        var productRecords = [TMProductRecord]()
        
        for product in takeOrder.list {
            var productRecord = TMProductRecord()
            productRecord.product_id = product.product_id
            productRecord.product_name = product.product_name
            productRecord.price = product.official_quotation
            productRecord.quantity = product.quantity
            
            productRecords.append(productRecord)
        }
        
        return productRecords
    }
    
    func setProductRecords(list: [TMProductRecord]) {
        takeOrder.list.removeAll(keepCapacity: false)
        
        for productRecord in list {
            var product = TMProduct()
            product.product_id = productRecord.product_id
            product.product_name = productRecord.product_name
            product.official_quotation = productRecord.price
            product.quantity = productRecord.quantity
            
            takeOrder.list.append(product)
        }
        
        // 刷新数据
        if let closure = refreshDataClosure {
            closure(self)
        }
    }
    
    
    func getOrder(hasUserInfo: Bool = true, status: TMOrderStatus = .TransactionDone) -> TMOrder {
        
        var order = TMOrder()
        
        if hasUserInfo {
            if let user = self.user {
                order.user_id = user.user_id
            } else {
                order.user_id = TMShop.sharedInstance.shop_id
            }
            order.actual_amount = NSNumber(double: getActualAmount())
            order.discount = NSNumber(double: getMaxDiscount() * 10) 
            order.user_mobile_number =  user?.mobile_number
        } else {
            order.actual_amount = NSNumber(double: getConsumeAmount())
            order.discount = 1.0 * 10
        }
        
        
        if isRestingOrder && orderIndex != nil {
            order.order_index = orderIndex
        }
        
        order.shop_id = TMShop.sharedInstance.shop_id
        order.business_id = TMShop.sharedInstance.business_id
        order.admin_id = TMShop.sharedInstance.admin_id
        order.transaction_mode = getTransactionMode()
        order.register_type = .Manually
        order.payable_amount = NSNumber(double: getConsumeAmount())
        order.coupon_id = ""
        order.discount_type = getDiscountType()
        order.register_time = NSDate()
        order.order_description = orderDescription
        order.status = status
        order.product_records = getProductRecords()
        return order
    }
}