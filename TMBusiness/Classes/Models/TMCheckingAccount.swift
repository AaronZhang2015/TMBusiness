//
//  TMCheckingAccount.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/27/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import Foundation


struct TMCheckingAccount {
    
    // 刷卡消费
    var box_amount: NSNumber = 0.0
    
    var alipay_amount: NSNumber = 0.0
    
    var cyber_bank_amount: NSNumber = 0.0
    
    var other_amount: NSNumber = 0.0
    
    // 优惠券
    var coupon_amount: NSNumber = 0.0
    
    // 折扣
    var discount_amount: NSNumber = 0.0
    
    // 实收
    var actual_amount: NSNumber = 0.0
    
    // 应收
    var amount: NSNumber = 0.0
    
    // 会员卡消费
    var balance_amount: NSNumber = 0.0
    
    // 现金消费
    var cash_amount: NSNumber = 0.0
    
    // 会员卡充值总额
    var recharge_amount: TMCheckingAccountRecharge = TMCheckingAccountRecharge()
    
    // 现金充值
    var recharge_cash: TMCheckingAccountRecharge = TMCheckingAccountRecharge()
    
    // 支付宝充值
    var recharge_alipay: TMCheckingAccountRecharge = TMCheckingAccountRecharge()
    
    // 银联卡充值
    var recharge_cyber_bank: TMCheckingAccountRecharge = TMCheckingAccountRecharge()
    
    // 刷卡充值
    var recharge_box: TMCheckingAccountRecharge = TMCheckingAccountRecharge()
    
    // 其他充值
    var recharge_other: TMCheckingAccountRecharge = TMCheckingAccountRecharge()
    
    // 寻觅充值补贴
    var subsidy: TMCheckingAccountSubSidy = TMCheckingAccountSubSidy()
    
    // 订单商品
    var products: [TMProductRecord] = [TMProductRecord]()
}


struct TMCheckingAccountRecharge {
    var actual_amount: NSNumber = 0.0
    var total_amount: NSNumber = 0.0
}


struct TMCheckingAccountSubSidy {
    var unclear: NSNumber = 0.0
    var total: NSNumber = 0.0
}