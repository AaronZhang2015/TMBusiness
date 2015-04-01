//
//  TMLoginView.swift
//  TMBusiness
//
//  Created by ZhangMing on 15/4/2.
//  Copyright (c) 2015年 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

class TMLoginView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // bg image view
        backgroundColor = UIColor(hex: 0xF4F4F4)
        
        var topImageView = UIImageView(image: UIImage(named: "loginbg_top"))
        topImageView.top = 0
        topImageView.left = 20
        addSubview(topImageView)
        
        var contentView = UIView(frame: CGRectMake(20, 9, 399, 321))
        contentView.backgroundColor = UIColor.clearColor()
        addSubview(contentView)
        
        var bgView = UIImageView(image: UIImage(named: "loginbg_content"))
        contentView.addSubview(bgView)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
