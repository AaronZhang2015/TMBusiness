//
//  TMUserParser.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/21/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

class TMParser: NSObject {
    
    /**
    解析User对象
    
    :param: json 带解析数据
    
    :returns: TMUser
    */
    class func parseUser(data: JSON) -> TMUser {
        var user = TMUser()
        user.user_id = data["user_id"].string
        user.real_name = data["real_name"].string
        user.nick_name = data["nick_name"].string
        user.landline_number = data["landline_number"].string
        user.mobile_number = data["mobile_number"].string
        user.qq = data["qq"].string
        user.email = data["email"].string
        user.province = data["province"].string
        user.city = data["city"].string
        user.weixin = data["weixin"].string
        user.weibo = data["weibo"].string
        user.renren = data["renren"].string
        user.head_image = data["head_image"].string
        
        // 解析用户余额
        user.user_account_balance = parseUserAccountBalance(data["user_account_balance"])
        
        // 解析充值记录
        user.recharge_record = parseRechargeRecord(data["recharge_record"])
        
        // 奖励记录
        user.reward_record = parseRewardRecord(data["reward_record"])
        
        return user
    }
    
    /**
    解析用户余额
    
    :param: data 待解析数据
    
    :returns: 用户余额
    */
    class func parseUserAccountBalance(data: JSON) -> [TMUserAccountBalance]? {
        var userAccountBalanceList: [TMUserAccountBalance]?
        
        if data != nil {
            userAccountBalanceList = [TMUserAccountBalance]()
            for (index: String, subJson: JSON) in data {
                var userAccountBalance = TMUserAccountBalance()
                userAccountBalance.amount = subJson["amount"].numberValue
                userAccountBalance.business_id = subJson["business_id"].string
                userAccountBalanceList!.append(userAccountBalance)
            }
        }
        
        return userAccountBalanceList
    }
    
    /**
    解析充值记录
    
    :param: data 待解析数据
    
    :returns: 充值记录列表
    */
    class func parseRechargeRecord(data: JSON) -> [TMRechargeRecord]? {
        var rechargeRecordList: [TMRechargeRecord]?
        
        if data != nil {
            rechargeRecordList = [TMRechargeRecord]()
            for (index: String, subJson: JSON) in data {
                var rechargeRecord = TMRechargeRecord()
                
                if let previous_recharge_date = subJson["previous_recharge_date"].string {
                    var date = NSDate(fromString: previous_recharge_date, format: .Custom("yyyy-MM-dd HH:mm:ss"))
                    rechargeRecord.previous_recharge_date = date
                }
                
                rechargeRecord.previous_recharge_number = subJson["previous_recharge_number"].string?.toNumber
                
                
                if let recharge_date = subJson["recharge_date"].string {
                    var date = NSDate(fromString: recharge_date, format: .Custom("yyyy-MM-dd HH:mm:ss"))
                    rechargeRecord.recharge_date = date
                }
                
                rechargeRecord.recharge_type = subJson["recharge_type"].string?.toNumber
                rechargeRecord.actual_amount = subJson["actual_amount"].string?.toNumber
                rechargeRecord.total_amount = subJson["total_amount"].string?.toNumber
                rechargeRecord.reward_id = subJson["reward_id"].string
                
                rechargeRecordList!.append(rechargeRecord)
            }
        }
        
        return rechargeRecordList
    }
    
    /**
    解析奖励记录数据
    
    :param: data 待解析数据
    
    :returns: 奖励列表
    */
    class func parseRewardRecord(data: JSON) -> [TMRewardRecord]? {
        var rewardRecordList: [TMRewardRecord]?
        if data != nil {
            rewardRecordList = [TMRewardRecord]()
            
            for (index: String, subJson: JSON) in data {
                var rewardRecord = TMRewardRecord()
                
                if let sign_previous_date = subJson["sign_previous_date"].string {
                    var date = NSDate(fromString: sign_previous_date, format: .Custom("yyyy-MM-dd HH:mm:ss"))
                    rewardRecord.sign_previous_date = date
                }
                
                rewardRecord.sign_number_current = subJson["sign_number_current"].string?.toNumber
                rewardRecord.sign_number_next_difference = subJson["sign_number_next_difference"].string?.toNumber
                rewardRecord.sign_reward_current = subJson["sign_reward_current"].string?.toNumber
                
                if let sign_reward_current_date = subJson["sign_reward_current_date"].string {
                    var date = NSDate(fromString: sign_reward_current_date, format: .Custom("yyyy-MM-dd HH:mm:ss"))
                    rewardRecord.sign_reward_current_date = date
                }
                
                rewardRecord.sign_reward_next = subJson["sign_reward_next"].string?.toNumber
                rewardRecord.consume_count_current = subJson["consume_count_current"].string?.toNumber
                rewardRecord.consume_number_current = subJson["consume_number_current"].string?.toNumber
                rewardRecord.consume_count_total = subJson["consume_count_total"].string?.toNumber
                rewardRecord.consume_number_total = subJson["consume_number_total"].string?.toNumber
                rewardRecord.consume_reward_current = subJson["consume_reward_current"].string?.toNumber
                
                rewardRecord.consume_number_next_difference = subJson["consume_number_next_difference"].string?.toNumber
                rewardRecord.consume_reward_next = subJson["consume_reward_next"].string?.toNumber
                
                if let consume_previous_date = subJson["sign_reward_current_date"].string {
                    var date = NSDate(fromString: consume_previous_date, format: .Custom("yyyy-MM-dd HH:mm:ss"))
                    rewardRecord.consume_previous_date = date
                }
                
                rewardRecord.consume_previous_number = subJson["consume_previous_number"].string?.toNumber
                
                rewardRecord.reward_record_sign_data_count = subJson["reward_record_sign_data_count"].string?.toNumber
                rewardRecord.type = subJson["type"].string?.toNumber
                
                // 解析shop
                var shop = parseShop(subJson["shop"])
                
                rewardRecord.shop = shop
                rewardRecordList!.append(rewardRecord)
            }
        }
        return rewardRecordList
    }
    
    /**
    解析商铺信息
    
    :param: data 待解析数据
    
    :returns: TMShop
    */
    class func parseShop(data: JSON) -> TMShop {
        var shop = TMShop()
        
        shop.shop_id = data["shop_id"].stringValue
        shop.shop_name = data["shop_name"].stringValue
        shop.admin_id = data["admin_id"].stringValue
        shop.address = data["address"].string
        shop.business_id = data["business_id"].stringValue
        shop.combination = data["combination"].stringValue
        shop.immediate = data["immediate"].stringValue
        
        // 解析奖励规则
        shop.rewards = parseReward(data["rewards"])
        
        return shop
    }
    
    
    /**
    解析奖励规则数据
    
    :param: data 待解析数据
    
    :returns: 奖励规则列表
    */
    class func parseReward(data: JSON) -> [TMReward] {
        var rewardsList = [TMReward]()
        for (index: String, subJson: JSON) in data {
            var reward = TMReward()
            reward.reward_id = subJson["reward_id"].string
            reward.type = subJson["type"].string?.toNumber
            reward.current_number_min = subJson["current_number_min"].string?.toNumber
            reward.current_number_max = subJson["current_number_max"].string?.toNumber
            reward.total_number_min = subJson["total_number_min"].string?.toNumber
            reward.total_number_max = subJson["total_number_max"].string?.toNumber
            reward.reward_description = subJson["reward_description"].string
            rewardsList.append(reward)
        }
        
        return rewardsList
    }
    
    /**
    解析消费记录
    
    :param: data 待解析数据
    
    :returns: 订单记录
    */
    class func parseOrder(data: JSON) -> TMOrder {
        var order = TMOrder()
        order.order_id = data["order_id"].string
        order.order_index = data["order_index"].string
        order.user_id = data["user_id"].string
        order.shop_id = data["shop_id"].string
        
        if let transaction_mode = data["transaction_mode"].string?.toNumber?.integerValue {
            if let mode =  TMTransactionMode(rawValue: transaction_mode) {
                order.transaction_mode = mode
            }
        }
        
        if let register_type = data["register_type"].string?.toNumber?.integerValue {
            if let type = TMRegisterType(rawValue: register_type) {
                order.register_type = type
            }
        }
        
        if let payable_amount = data["payable_amount"].string?.toNumber {
            order.payable_amount = payable_amount
        }
        
        if let actual_amount = data["actual_amount"].string?.toNumber {
            order.actual_amount = actual_amount
        }
        
        if let discount_type = data["discount_type"].string?.toNumber?.integerValue {
            if let type = TMDiscountType(rawValue: discount_type) {
                order.discount_type = type
            }
        }
        
        if let order_status = data["status"].string?.toNumber?.integerValue {
            if let status = TMOrderStatus(rawValue: order_status) {
                order.status = status
            }
        }
        
        order.coupon_id = data["coupon_id"].string
        order.discount = data["discount"].string?.toNumber
        order.register_time = parseDate(data["register_time"].string)
        order.user_mobile_number = data["user_mobile_number"].string
        order.order_description = data["description"].string
        
        // 解析订单商品详情
        var productRecordList = [TMProductRecord]()
        for (index: String, subJson: JSON) in data["product_record"] {
            var productRecord = parseProductRecord(subJson)
            productRecordList.append(productRecord)
        }
        order.product_records = productRecordList
        
        return order
    }
    
    
    /**
    解析订单商品记录
    
    :param: data 待解析数据
    
    :returns: 订单商品记录
    */
    class func parseProductRecord(data: JSON) -> TMProductRecord {
        var productRecord = TMProductRecord()
        productRecord.product_id = data["product_id"].string
        productRecord.product_name = data["product_name"].string
        
        if let price = data["price"].string?.toNumber {
            productRecord.price = price
        }
        
        if let quantity = data["quantity"].string?.toNumber {
            productRecord.quantity = quantity
        }
        
        if let actual_amount = data["actual_amount"].string?.toNumber {
            productRecord.actual_amount = actual_amount
        }
        
        if let total_amount = data["total_amount"].string?.toNumber {
            productRecord.total_amount = total_amount
        }
        
        return productRecord
    }
    
    
    /**
    解析对账单接口
    
    :param: data 待解析数据
    
    :returns: 对账单
    */
    class func parseCheckingAccountRecord(data: JSON) -> TMCheckingAccount {
        var checkingAccount = TMCheckingAccount()
        checkingAccount.box_amount = data["box_amount"].numberValue
        checkingAccount.alipay_amount = data["alipay_amount"].numberValue
        checkingAccount.cyber_bank_amount = data["cyber_bank_amount"].numberValue
        checkingAccount.other_amount = data["other_amount"].numberValue
        checkingAccount.cash_amount = data["cash_amount"].numberValue
        checkingAccount.balance_amount = data["balance_amount"].numberValue
        checkingAccount.amount = data["amount"].numberValue
        checkingAccount.actual_amount = data["actual_amount"].numberValue
        checkingAccount.discount_amount = data["discount_amount"].numberValue
        checkingAccount.coupon_amount = data["coupon_amount"].numberValue
        
        checkingAccount.recharge_amount = parseCheckingAccountRecharge(data["recharge"]["recharge_amount"])
        checkingAccount.recharge_cash = parseCheckingAccountRecharge(data["recharge"]["recharge_cash"])
        checkingAccount.recharge_alipay = parseCheckingAccountRecharge(data["recharge"]["recharge_alipay"])
        checkingAccount.recharge_cyber_bank = parseCheckingAccountRecharge(data["recharge"]["recharge_cyber_bank"])
        checkingAccount.recharge_box = parseCheckingAccountRecharge(data["recharge"]["recharge_box"])
        checkingAccount.recharge_other = parseCheckingAccountRecharge(data["recharge"]["recharge_other"])
        
        var subsidy = TMCheckingAccountSubSidy()
        subsidy.unclear = data["recharge"]["subsidy"]["unclear"].numberValue
        subsidy.total = data["recharge"]["subsidy"]["total"].numberValue
        
        checkingAccount.subsidy = subsidy
        
        // 解析商品
        var products = [TMProductRecord]()
        
        for (index: String, subJson: JSON) in data["product"] {
            var product = parseProductRecord(subJson)
            products.append(product)
        }
        
        checkingAccount.products = products
        
        return checkingAccount
    }
    
    
    class func parseCheckingAccountRecharge(data: JSON) -> TMCheckingAccountRecharge {
        var recharge = TMCheckingAccountRecharge()
        recharge.actual_amount = data["actual_amount"].numberValue
        recharge.total_amount = data["total_amount"].numberValue
        return recharge
    }
    
    
    
    // MARK: - Helper
    class func parseDate(dateString: String?) -> NSDate? {
        if let dateString = dateString {
            var date = NSDate(fromString: dateString, format: .Custom("yyyy-MM-dd HH:mm:ss"))
            return date
        }
        
        return nil
    }
}
