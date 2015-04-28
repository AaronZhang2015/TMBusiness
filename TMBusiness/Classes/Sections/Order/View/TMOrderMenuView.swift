//
//  TMOrderMenuView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/28/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

class TMOrderMenuView: UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0xF5F5F5)
        
        var restingButton = UIButton.buttonWithType(.Custom) as! UIButton
        restingButton.setBackgroundImage(UIImage(named: "order_menu"), forState: .Normal)
        restingButton.setBackgroundImage(UIImage(named: "order_menu_on"), forState: .Highlighted)
        restingButton.setTitle("挂单", forState: .Normal)
        restingButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        restingButton.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0)
        restingButton.imageEdgeInsets = UIEdgeInsetsMake(0, 130, 0, 0)
        restingButton.setImage(UIImage(named: "order_arrow"), forState: .Normal)
        restingButton.setImage(UIImage(named: "order_arrow_on"), forState: .Highlighted)
        restingButton.setTitleColor(UIColor(hex: 0x222222), forState: .Normal)
        restingButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(restingButton)
        restingButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(150, 50))
            make.top.equalTo(17)
            make.leading.equalTo(0)
        }
        
        var waitForPayingButton = UIButton.buttonWithType(.Custom) as! UIButton
        waitForPayingButton.setBackgroundImage(UIImage(named: "order_menu"), forState: .Normal)
        waitForPayingButton.setBackgroundImage(UIImage(named: "order_menu_on"), forState: .Highlighted)
        waitForPayingButton.setTitle("未支付", forState: .Normal)
        waitForPayingButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        waitForPayingButton.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0)
        waitForPayingButton.imageEdgeInsets = UIEdgeInsetsMake(0, 130, 0, 0)
        waitForPayingButton.setImage(UIImage(named: "order_arrow"), forState: .Normal)
        waitForPayingButton.setImage(UIImage(named: "order_arrow_on"), forState: .Highlighted)
        waitForPayingButton.setTitleColor(UIColor(hex: 0x222222), forState: .Normal)
        waitForPayingButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(waitForPayingButton)
        waitForPayingButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(150, 50))
            make.top.equalTo(restingButton.snp_bottom)
            make.leading.equalTo(0)
        }
        
        var payDoneButton = UIButton.buttonWithType(.Custom) as! UIButton
        payDoneButton.setBackgroundImage(UIImage(named: "order_menu"), forState: .Normal)
        payDoneButton.setBackgroundImage(UIImage(named: "order_menu_on"), forState: .Highlighted)
        payDoneButton.setTitle("已完成", forState: .Normal)
        payDoneButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        payDoneButton.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0)
        payDoneButton.imageEdgeInsets = UIEdgeInsetsMake(0, 130, 0, 0)
        payDoneButton.setImage(UIImage(named: "order_arrow"), forState: .Normal)
        payDoneButton.setImage(UIImage(named: "order_arrow_on"), forState: .Highlighted)
        payDoneButton.setTitleColor(UIColor(hex: 0x222222), forState: .Normal)
        payDoneButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(payDoneButton)
        payDoneButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(150, 50))
            make.top.equalTo(waitForPayingButton.snp_bottom)
            make.leading.equalTo(0)
        }
    }
}
