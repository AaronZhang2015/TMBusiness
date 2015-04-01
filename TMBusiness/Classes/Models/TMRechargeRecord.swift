//
//  TMRechargeRecord.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 3/30/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit


/**
*  充值记录实体模型
*/
class TMRechargeRecord: NSObject {
   
    // 最后一次充值日期
    var previous_recharge_date: NSDate?
    
    // 最后一次充值金额
    var previous_recharge_number: NSNumber?
    
    // 充值日期
    var recharge_date: NSDate?
    
    // 充值方式（1：现金 2：支付宝 3：网银）
    var recharge_type: NSNumber?
    
    // 实际充值金额
    var actual_amount: NSNumber?
    
    // 到账充值金额
    var total_amount: NSNumber?
    
    // 奖励设置记录编号
    var reward_id: String?
}


/*
previous_recharge_date					最后一次充值日期
previous_recharge_number				最后一次充值金额
recharge_date							充值日期
recharge_type							充值方式（1：现金 2：支付宝 3：网银）
actual_amount						实际充值金额
total_amount							到账充值金额
reward_id							奖励设置记录编号
*/