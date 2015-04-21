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
    
}
