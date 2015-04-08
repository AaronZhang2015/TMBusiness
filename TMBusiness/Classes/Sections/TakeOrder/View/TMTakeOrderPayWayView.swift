//
//  TMTakeOrderPayWayView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/2/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit


enum TMPayType {
    case Cash
    case BankCard
    case MembershipCard
    case Other
}

class TMTakeOrderPayWayView: UIView {
    // 会员支付，余额支付
    var balancePayButton: UIButton!
    
    // 现金支付
    var cashPayButton: UIButton!
    
    // 刷卡支付
    var cardPayButton: UIButton!
    
    // 其他支付
    var otherPayButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // ----
        balancePayButton = UIButton.buttonWithType(.Custom) as UIButton
        balancePayButton.frame = CGRectMake(60, 30, 80, 80)
        balancePayButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        balancePayButton.setBackgroundImage(UIImage(named: "anniu"), forState: .Normal)
        balancePayButton.setBackgroundImage(UIImage(named: "anniu_on"), forState: .Highlighted)
        balancePayButton.setTitle("会员卡", forState: .Normal)
        balancePayButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        balancePayButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(balancePayButton)
        
        // -----
        cashPayButton = UIButton.buttonWithType(.Custom) as UIButton
        cashPayButton.frame = CGRectMake(160, balancePayButton.top, balancePayButton.width, balancePayButton.height)
        cashPayButton.titleLabel?.font = balancePayButton.titleLabel?.font
        cashPayButton.setBackgroundImage(UIImage(named: "anniu"), forState: .Normal)
        cashPayButton.setBackgroundImage(UIImage(named: "anniu_on"), forState: .Highlighted)
        cashPayButton.setTitle("现金", forState: .Normal)
        cashPayButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cashPayButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(cashPayButton)
        
        // -----
        cardPayButton = UIButton.buttonWithType(.Custom) as UIButton
        cardPayButton.frame = CGRectMake(260, balancePayButton.top, balancePayButton.width, balancePayButton.height)
        cardPayButton.titleLabel?.font = balancePayButton.titleLabel?.font
        cardPayButton.setBackgroundImage(UIImage(named: "anniu"), forState: .Normal)
        cardPayButton.setBackgroundImage(UIImage(named: "anniu_on"), forState: .Highlighted)
        cardPayButton.setTitle("刷卡", forState: .Normal)
        cardPayButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cardPayButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(cardPayButton)
        
        // -----
        otherPayButton = UIButton.buttonWithType(.Custom) as UIButton
        otherPayButton.frame = CGRectMake(360, balancePayButton.top, balancePayButton.width, balancePayButton.height)
        otherPayButton.titleLabel?.font = balancePayButton.titleLabel?.font
        otherPayButton.setBackgroundImage(UIImage(named: "anniu"), forState: .Normal)
        otherPayButton.setBackgroundImage(UIImage(named: "anniu_on"), forState: .Highlighted)
        otherPayButton.setTitle("其他", forState: .Normal)
        otherPayButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        otherPayButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(otherPayButton)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
