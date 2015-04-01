//
//  TMReward.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 3/30/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import Foundation


/**
*  奖励信息实体模型
*/
class TMReward: NSObject {
    // 奖励编号
    var reward_id:String?
    
    // 奖励类型（1：签到次数奖励）
    var type: NSNumber?
    
    // 当前的数值限制最低
    var current_number_min: NSNumber?
    
    // 当前的数值限制最高
    var current_number_max: NSNumber?
    
    // 累计的数值限制最低
    var total_number_min: NSNumber?
    
    // 累计的数值限制最高
    var total_number_max: NSNumber?
    
    // 奖励内容
    var reward_description: String?
}

/*
reward_id							奖励编号
type									奖励类型（1：签到次数奖励）
current_number_min				当前的数值限制最低
current_number_max					当前的数值限制最高
total_number_min						累计的数值限制最低
total_number_max						累计的数值限制最高
reward_description						奖励内容
*/