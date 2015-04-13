//
//  TMTakeOrderPayWayView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/2/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap


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
        
        var titleLabel = UILabel()
        titleLabel.textColor = UIColor(hex: 0x222222)
        titleLabel.font = UIFont.systemFontOfSize(18.0)
        titleLabel.text = "结算方式"
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        titleLabel.snp_makeConstraints { make in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(16)
            make.height.greaterThanOrEqualTo(80)
            make.width.equalTo(21)
        }
        
        // 分割线
        var separatorView = UIImageView(image: UIImage(named: "order_separator"))
        addSubview(separatorView)
        separatorView.snp_makeConstraints { make in
            make.top.equalTo(self.snp_top).offset(14)
            make.width.equalTo(1)
            make.bottom.equalTo(self.snp_bottom).offset(-14)
            make.left.equalTo(titleLabel.snp_trailing).offset(14)
        }
        
        // ----
        balancePayButton = UIButton.buttonWithType(.Custom) as! UIButton
        balancePayButton.titleLabel?.font = UIFont.systemFontOfSize(22)
        balancePayButton.setBackgroundImage(UIImage(named: "anniu"), forState: .Normal)
        balancePayButton.setBackgroundImage(UIImage(named: "anniu_on"), forState: .Highlighted)
        balancePayButton.setTitle("会员", forState: .Normal)
        balancePayButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        balancePayButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(balancePayButton)
        balancePayButton.snp_makeConstraints { make in
            make.size.equalTo(CGSizeMake(90, 90))
            make.left.equalTo(separatorView.snp_trailing).offset(15)
            make.centerY.equalTo(self.snp_centerY)
        }
        
        // -----
        cashPayButton = UIButton.buttonWithType(.Custom) as! UIButton
        cashPayButton.titleLabel?.font = balancePayButton.titleLabel?.font
        cashPayButton.setBackgroundImage(UIImage(named: "anniu"), forState: .Normal)
        cashPayButton.setBackgroundImage(UIImage(named: "anniu_on"), forState: .Highlighted)
        cashPayButton.setTitle("现金", forState: .Normal)
        cashPayButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cashPayButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(cashPayButton)
        cashPayButton.snp_makeConstraints { make in
            make.size.equalTo(CGSizeMake(90, 90))
            make.left.equalTo(self.balancePayButton.snp_trailing).offset(8)
            make.centerY.equalTo(self.snp_centerY)
        }
        
        // -----
        cardPayButton = UIButton.buttonWithType(.Custom) as! UIButton
        cardPayButton.titleLabel?.font = balancePayButton.titleLabel?.font
        cardPayButton.setBackgroundImage(UIImage(named: "anniu"), forState: .Normal)
        cardPayButton.setBackgroundImage(UIImage(named: "anniu_on"), forState: .Highlighted)
        cardPayButton.setTitle("刷卡", forState: .Normal)
        cardPayButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cardPayButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(cardPayButton)
        cardPayButton.snp_makeConstraints { make in
            make.size.equalTo(CGSizeMake(90, 90))
            make.left.equalTo(self.cashPayButton.snp_trailing).offset(8)
            make.centerY.equalTo(self.snp_centerY)
        }
        
        // -----
        otherPayButton = UIButton.buttonWithType(.Custom) as! UIButton
        otherPayButton.titleLabel?.font = balancePayButton.titleLabel?.font
        otherPayButton.setBackgroundImage(UIImage(named: "anniu"), forState: .Normal)
        otherPayButton.setBackgroundImage(UIImage(named: "anniu_on"), forState: .Highlighted)
        otherPayButton.setTitle("其他", forState: .Normal)
        otherPayButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        otherPayButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(otherPayButton)
        otherPayButton.snp_makeConstraints { make in
            make.size.equalTo(CGSizeMake(90, 90))
            make.left.equalTo(self.cardPayButton.snp_trailing).offset(8)
            make.centerY.equalTo(self.snp_centerY)
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
