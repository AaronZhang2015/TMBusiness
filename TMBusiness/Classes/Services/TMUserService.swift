//
//  TMUserService.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 15/3/5.
//  Copyright (c) 2015年 ZhangMing. All rights reserved.
//

import UIKit
import Alamofire

enum TMConditionType: Int {
    case MobileNumber = 1
    case UserId = 2
}

class TMUserService: NSObject {
    
    lazy var manager: TMNetworkManager = {
        return TMNetworkManager()
    }()
   
    // 商户用户登录
    func login(username: String , password: String, completion: (TMShop?, NSError?) -> Void) {
        manager.request(.POST, relativePath: "shop_login", parameters: ["login_account" : username, "login_password" : password, "device_type" : AppManager.platform().rawValue]) { (result) -> Void in
            switch result {
            case let .Error(e):
                completion(nil, e)
            case let .Value(json):
                // 解析数据
                let data = json["data"]
                
                var shop = TMShop.sharedInstance
                shop.shop_id = data["shop_id"].stringValue
                shop.shop_name = data["shop_name"].stringValue
                shop.admin_id = data["admin_id"].stringValue
                shop.address = data["address"].string
                shop.business_id = data["business_id"].stringValue
                
                completion(shop, nil)
            }
        }
    }
    
    // 获取用户基本信息
    func fetchUserInfo() {
        manager.request(.POST, relativePath: "user_getEntityDetailInfo", parameters: ["user_id": TMShop.sharedInstance.admin_id!, "device_type" : AppManager.platform().rawValue]) { (result) -> Void in
            switch result {
            case let .Error(e):
                println(e)
            case let .Value(json):
                // 解析数据
                let data = json["data"]
                println(data)
            }
            
        }
    }
    
    func fetchEntityAllInfo(condition: String, type: TMConditionType, shopId: String, businessId: String, adminId: String, completion: (TMUser?, NSError?) -> Void) {
        manager.request(.POST, relativePath: "user_getEntityAllInfo", parameters: ["condition": condition, "type": type.rawValue, "shop_id": shopId, "business_id": businessId, "admin_id": adminId, "device_type" : AppManager.platform().rawValue]) { (result) -> Void in
            switch result {
            case let .Error(e):
                completion(nil, e)
            case let .Value(json):
                // 解析数据
                let data = json["data"]
                
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
                var userAccountBalanceList: [TMUserAccountBalance]?
                var user_account_balance = data["user_account_balance"]
                if  user_account_balance != nil {
                    userAccountBalanceList = [TMUserAccountBalance]()
                    for (index: String, subJson: JSON) in user_account_balance {
                        var userAccountBalance = TMUserAccountBalance()
                        userAccountBalance.amount = subJson["amount"].numberValue
                        userAccountBalance.business_id = subJson["business_id"].string
                        userAccountBalanceList!.append(userAccountBalance)
                    }
                }
                user.user_account_balance = userAccountBalanceList
                
                // 解析充值记录
                var rechargeRecordList: [TMRechargeRecord]?
                var recharge_record = data["recharge_record"]
                if recharge_record != nil {
                    rechargeRecordList = [TMRechargeRecord]()
                    for (index: String, subJson: JSON) in recharge_record {
                        var rechargeRecord = TMRechargeRecord()
                        var previous_recharge_date = subJson["previous_recharge_date"].stringValue
                        var date = NSDate(fromString: previous_recharge_date, format: .Custom("yyyy-MM-dd HH:mm:ss"))
                        rechargeRecord.previous_recharge_date = date
                        
                        rechargeRecord.previous_recharge_number = subJson["previous_recharge_number"].numberValue
                        
                        var recharge_date = subJson["recharge_date"].stringValue
                        date = NSDate(fromString: recharge_date, format: .Custom("yyyy-MM-dd HH:mm:ss"))
                        rechargeRecord.recharge_date = date
                        
                        // 需要分析如果有数值的时候，是不是为nil
                        rechargeRecord.recharge_type = subJson["recharge_type"].number
                        rechargeRecord.actual_amount = subJson["actual_amount"].number
                        rechargeRecord.total_amount = subJson["total_amount"].number
                        rechargeRecord.reward_id = subJson["reward_id"].string
                        
                        rechargeRecordList!.append(rechargeRecord)
                    }
                }
                
                user.recharge_record = rechargeRecordList
                
                // 奖励记录
                var rewardRecordList: [TMRewardRecord]?
                var reward_record = data["reward_record"]
                if reward_record != nil {
                    rewardRecordList = [TMRewardRecord]()
                    for (index: String, subJson: JSON) in reward_record {
                        var rewardRecord = TMRewardRecord()
                        
                        var sign_previous_date = subJson["sign_previous_date"].stringValue
                        var date = NSDate(fromString: sign_previous_date, format: .Custom("yyyy-MM-dd HH:mm:ss"))
                        rewardRecord.sign_previous_date = date
                        
                        rewardRecord.sign_number_current = subJson["sign_number_current"].number
                        rewardRecord.sign_number_next_difference = subJson["sign_number_next_difference"].number
                        rewardRecord.sign_reward_current = subJson["sign_reward_current"].number
                        
                        var sign_reward_current_date = subJson["sign_reward_current_date"].stringValue
                        date = NSDate(fromString: sign_reward_current_date, format: .Custom("yyyy-MM-dd HH:mm:ss"))
                        rewardRecord.sign_reward_current_date = date
                        
                        rewardRecord.sign_reward_next = subJson["sign_reward_next"].number
                        rewardRecord.consume_count_current = subJson["consume_count_current"].number
                        rewardRecord.consume_number_current = subJson["consume_number_current"].number
                        rewardRecord.consume_count_total = subJson["consume_count_total"].number
                        rewardRecord.consume_number_total = subJson["consume_number_total"].number
                        rewardRecord.consume_reward_current = subJson["consume_reward_current"].number
                        rewardRecord.consume_number_next_difference = subJson["consume_number_next_difference"].number
                        rewardRecord.consume_reward_next = subJson["consume_reward_next"].number
                        
                        var consume_previous_date = subJson["sign_reward_current_date"].stringValue
                        date = NSDate(fromString: consume_previous_date, format: .Custom("yyyy-MM-dd HH:mm:ss"))
                        rewardRecord.consume_previous_date = date
                        
                        rewardRecord.consume_previous_number = subJson["consume_previous_number"].number
                        
                        rewardRecord.reward_record_sign_data_count = subJson["reward_record_sign_data_count"].number
                        rewardRecord.type = subJson["type"].numberValue
                        
                        // 解析shop
                        var shop = TMShop()
                        shop.shop_id = subJson["shop"]["shop_id"].stringValue
                        shop.shop_name = subJson["shop"]["shop_name"].stringValue
                        shop.admin_id = subJson["shop"]["admin_id"].stringValue
                        shop.address = subJson["shop"]["address"].string
                        shop.business_id = subJson["shop"]["business_id"].stringValue
                        shop.combination = subJson["shop"]["combination"].stringValue
                        shop.immediate = subJson["shop"]["immediate"].stringValue
                        
                        rewardRecord.shop = shop
                        rewardRecordList!.append(rewardRecord)
                    }
                }
                user.reward_record = rewardRecordList
                
                completion(user, nil)
            }
        }
    }
}
