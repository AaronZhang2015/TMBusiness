//
//  TMOrderProductListMenuView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/30/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

/**
*  取消，改单，结账，下单
*/
class TMRestingOrderMenuView: UIView {
    
    var dashView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "checking_account_dash_line"))
        return imageView
        }()
    
    var cancelButton: UIButton = {
        var button = UIButton.buttonWithType(.Custom) as! UIButton
        button.setBackgroundImage(UIImage(named: "home_order"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "home_order_on"), forState: .Highlighted)
        button.setTitle("取消", forState: .Normal)
        button.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        return button
        }()
    
    var changeButton: UIButton = {
        var button = UIButton.buttonWithType(.Custom) as! UIButton
        button.setBackgroundImage(UIImage(named: "home_order"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "home_order_on"), forState: .Highlighted)
        button.setTitle("改单", forState: .Normal)
        button.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        return button
        }()
    
    var checkOutButton: UIButton = {
        var button = UIButton.buttonWithType(.Custom) as! UIButton
        button.setBackgroundImage(UIImage(named: "home_order"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "home_order_on"), forState: .Highlighted)
        button.setTitle("结账", forState: .Normal)
        button.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        return button
        }()
    
    var takeOrderButton: UIButton = {
        var button = UIButton.buttonWithType(.Custom) as! UIButton
        button.setBackgroundImage(UIImage(named: "home_order_on"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "home_order"), forState: .Highlighted)
        button.setTitle("下单", forState: .Normal)
        button.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Highlighted)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return button
        }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dashView)
        dashView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(1)
        }
        
        addSubview(cancelButton)
        cancelButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(80, 50))
            make.leading.equalTo(10)
            make.bottom.equalTo(-40)
        }
        
        addSubview(changeButton)
        changeButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(80, 50))
            make.leading.equalTo(cancelButton.snp_trailing).offset(10)
            make.bottom.equalTo(-40)
        }
        
        addSubview(checkOutButton)
        checkOutButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(80, 50))
            make.leading.equalTo(changeButton.snp_trailing).offset(10)
            make.bottom.equalTo(-40)
        }
        
        addSubview(takeOrderButton)
        takeOrderButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.leading.equalTo(checkOutButton.snp_trailing).offset(10)
            make.bottom.equalTo(-40)
            make.trailing.equalTo(-10)
        }
    }
}
