//
//  TMRewardRecord.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 3/30/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import Foundation


/**
*  奖励记录信息实体模型
*/
class TMRewardRecord: NSObject {
    
    // reward
    
    // 奖励记录的类型（1：签到次数 2:消费奖励 3:充值）
    var type: NSNumber?
    
    // 商铺信息实体模型
    var shop: TMShop?
    
    // 当前签到次数
    var sign_number_current: NSNumber?
    
    // 距离下阶段奖励的签到次数差
    var sign_number_next_difference: NSNumber?
    
    // 当前签到奖励
    var sign_reward_current: NSNumber?
    
    // 当前签到奖励时间
    var sign_reward_current_date: NSDate?
    
    // 下阶段签到奖励
    var sign_reward_next: NSNumber?
    
    // 最后一次签到时间
    var sign_previous_date: NSDate?
    
    // 当前消费累计次数
    var consume_count_current: NSNumber?
    
    // 当前消费累计金额
    var consume_number_current: NSNumber?
    
    // 消费总次数
    var consume_count_total: NSNumber?
    
    // 消费总金额
    var consume_number_total: NSNumber?
    
    // 当前消费奖励
    var consume_reward_current: NSNumber?
    
    // 距离下阶段奖励的消费金额差
    var consume_number_next_difference: NSNumber?
    
    // 下阶段消费奖励
    var consume_reward_next: NSNumber?
    
    // 最后一次消费时间
    var consume_previous_date: NSDate?
    
    // 最后一次消费金额
    var consume_previous_number: NSNumber?
    
    // 签到总次数
    var reward_record_sign_data_count: NSNumber?
}


/*
type									奖励记录的类型（1：签到次数 2:消费奖励）
shop									商铺信息实体模型
sign_number_current					当前签到次数
sign_number_next_difference			距离下阶段奖励的签到次数差
sign_reward_current					当前签到奖励
sign_reward_current_date				当前签到奖励时间
sign_reward_next						下阶段签到奖励
sign_previous_date						最后一次签到时间
consume_count_current					当前消费累计次数
consume_number_current				当前消费累计金额
consume_reward_current				当前消费奖励
consume_number_next_difference		距离下阶段奖励的消费金额差
consume_reward_next					下阶段消费奖励
consume_previous_date					最后一次消费时间
consume_previous_number				最后一次消费金额
reward_record_sign_data_count			签到总次数
*/