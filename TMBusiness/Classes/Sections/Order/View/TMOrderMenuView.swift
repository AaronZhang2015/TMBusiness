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
    
    private var restingButton: UIButton!
    private var waitForPayingButton: UIButton!
    private var payDoneButton: UIButton!
    
    var didSelectedIndexClosure: (Int -> Void)?
    
    lazy var separatorView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "checking_account_separator"))
        return imageView
        }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()//UIColor(hex: 0xF5F5F5)
        
        restingButton = UIButton.buttonWithType(.Custom) as! UIButton
        restingButton.setBackgroundImage(UIImage(named: "order_menu"), forState: .Normal)
        restingButton.setBackgroundImage(UIImage(named: "order_menu_on"), forState: .Highlighted)
        restingButton.setBackgroundImage(UIImage(named: "order_menu_on"), forState: .Selected)
        restingButton.setBackgroundImage(UIImage(named: "order_menu_on"), forState: .Selected | .Highlighted)
        restingButton.setTitle("挂单    ", forState: .Normal)
        restingButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        restingButton.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0)
        restingButton.imageEdgeInsets = UIEdgeInsetsMake(0, 120, 0, 0)
        restingButton.titleLabel?.textAlignment = .Left
        
        restingButton.setImage(UIImage(named: "order_arrow"), forState: .Normal)
        restingButton.setImage(UIImage(named: "order_arrow_on"), forState: .Highlighted)
        restingButton.setImage(UIImage(named: "order_arrow_on"), forState: .Selected)
        restingButton.setImage(UIImage(named: "order_arrow_on"), forState: .Selected | .Highlighted)
        
        restingButton.setTitleColor(UIColor(hex: 0x222222), forState: .Normal)
        restingButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        restingButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        restingButton.setTitleColor(UIColor.whiteColor(), forState: .Selected | .Highlighted)
        
        restingButton.addTarget(self, action: "handleOrderStatusSelectedAction:", forControlEvents: .TouchUpInside)
        addSubview(restingButton)
        restingButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(140, 50))
            make.top.equalTo(17)
            make.leading.equalTo(0)
        }
        
        waitForPayingButton = UIButton.buttonWithType(.Custom) as! UIButton
        waitForPayingButton.setBackgroundImage(UIImage(named: "order_menu"), forState: .Normal)
        waitForPayingButton.setBackgroundImage(UIImage(named: "order_menu_on"), forState: .Highlighted)
        waitForPayingButton.setBackgroundImage(UIImage(named: "order_menu_on"), forState: .Selected)
        waitForPayingButton.setBackgroundImage(UIImage(named: "order_menu_on"), forState: .Selected | .Highlighted)
        
        waitForPayingButton.setTitle("未支付", forState: .Normal)
        waitForPayingButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        waitForPayingButton.titleLabel?.textAlignment = .Left
        waitForPayingButton.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0)
        waitForPayingButton.imageEdgeInsets = UIEdgeInsetsMake(0, 120, 0, 0)
        waitForPayingButton.setImage(UIImage(named: "order_arrow"), forState: .Normal)
        waitForPayingButton.setImage(UIImage(named: "order_arrow_on"), forState: .Highlighted)
        waitForPayingButton.setImage(UIImage(named: "order_arrow_on"), forState: .Selected)
        waitForPayingButton.setImage(UIImage(named: "order_arrow_on"), forState: .Selected | .Highlighted)
        
        waitForPayingButton.setTitleColor(UIColor(hex: 0x222222), forState: .Normal)
        waitForPayingButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        waitForPayingButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        waitForPayingButton.setTitleColor(UIColor.whiteColor(), forState: .Selected | .Highlighted)
        
        waitForPayingButton.addTarget(self, action: "handleOrderStatusSelectedAction:", forControlEvents: .TouchUpInside)
        addSubview(waitForPayingButton)
        waitForPayingButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(140, 50))
            make.top.equalTo(restingButton.snp_bottom)
            make.leading.equalTo(0)
        }
        
        payDoneButton = UIButton.buttonWithType(.Custom) as! UIButton
        payDoneButton.setBackgroundImage(UIImage(named: "order_menu"), forState: .Normal)
        payDoneButton.setBackgroundImage(UIImage(named: "order_menu_on"), forState: .Highlighted)
        payDoneButton.setBackgroundImage(UIImage(named: "order_menu_on"), forState: .Selected)
        payDoneButton.setBackgroundImage(UIImage(named: "order_menu_on"), forState: .Selected | .Highlighted)
        
        payDoneButton.setTitle("已完成", forState: .Normal)
        payDoneButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        payDoneButton.titleLabel?.textAlignment = .Left
        payDoneButton.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0)
        payDoneButton.imageEdgeInsets = UIEdgeInsetsMake(0, 120, 0, 0)
        payDoneButton.setImage(UIImage(named: "order_arrow"), forState: .Normal)
        payDoneButton.setImage(UIImage(named: "order_arrow_on"), forState: .Highlighted)
        payDoneButton.setImage(UIImage(named: "order_arrow_on"), forState: .Selected)
        payDoneButton.setImage(UIImage(named: "order_arrow_on"), forState: .Selected | .Highlighted)
        
        payDoneButton.setTitleColor(UIColor(hex: 0x222222), forState: .Normal)
        payDoneButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        payDoneButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        payDoneButton.setTitleColor(UIColor.whiteColor(), forState: .Selected | .Highlighted)
        
        payDoneButton.addTarget(self, action: "handleOrderStatusSelectedAction:", forControlEvents: .TouchUpInside)
        addSubview(payDoneButton)
        payDoneButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(140, 50))
            make.top.equalTo(waitForPayingButton.snp_bottom)
            make.leading.equalTo(0)
        }
        
        addSubview(separatorView)
        separatorView.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(10)
            make.bottom.equalTo(0)
        }
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        if let superview = newSuperview {
//            waitForPayingButton.sendActionsForControlEvents(.TouchUpInside)
            waitForPayingButton.selected = true
        }
    }
    
    func handleOrderStatusSelectedAction(sender: UIButton!) {
        if sender.selected {
            return
        }
        
        resetButtonStatus()
        
        sender.selected = true
        
        if let closure = didSelectedIndexClosure {
            if sender == restingButton {
                closure(0)
            } else if sender == waitForPayingButton {
                closure(1)
            } else {
                closure(2)
            }
        }

    }
    
    func resetButtonStatus() {
        payDoneButton.selected = false
        waitForPayingButton.selected = false
        restingButton.selected = false
    }
}
