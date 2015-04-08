//
//  TMCashPayView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/8/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

/**
*  现金支付页面
*/
class TMCashPayView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var backButton = UIButton.buttonWithType(.Custom) as UIButton
        backButton.setImage(UIImage(named: "back"), forState: .Normal)
        backButton.setImage(UIImage(named: "back_on"), forState: .Highlighted)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -48)
        backButton.setTitle("返回", forState: .Normal)
        backButton.frame = CGRectMake(25, 12, 80, 35)
        addSubview(backButton)
        
    }

    required init(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
}
