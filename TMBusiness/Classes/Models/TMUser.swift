//
//  TMUser.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 3/30/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit


/**
*  终端用户实体模型
*/
class TMUser: NSObject {
    
    // 终端用户编号
    var user_id: String?
    
    // 真实姓名
    var real_name: String?
    
    // 昵称
    var nick_name: String?
    
    // 座机号
    var landline_number: String?
    
    // 手机号
    var mobile_number: String?
    
    // QQ
    var qq: String?
    
    // 电子邮箱
    var email: String?
    
    // 省份
    var province: String?
    
    // 城市
    var city: String?
    
    // 微信
    var weixin: String?
    
    // 微博
    var weibo: String?
    
    // 人人
    var renren: String?
    
    // 头像
    var head_image: String?
    
    // 奖励记录（数组）
//    var reward_record: []
    
    // 多个终端用户账户余额信息实体模型（数组）
    var user_account_balance: [TMUserAccountBalance]?
    
    // 多个充值记录实体模型（数组）
//    var recharge_record: []?
    
    class var sharedInstance: TMUser {
        struct Singleton {
            static let instance = TMUser()
        }
        return Singleton.instance
    }
}

/*
user_id									终端用户编号
real_name								真实姓名
nick_name								昵称
landline_number							座机号
mobile_number							手机号
qq										QQ
email									电子邮箱
address									常用住址
province									省份
city										城市
weixin									微信
weibo									微博
renren									人人
head_image								头像
reward_record							奖励记录（数组）
user_account_balance						多个终端用户账户余额信息实体模型（数组）
recharge_record							多个充值记录实体模型（数组）
*/