//
//  TMOrderRemarkView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/7/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit


/**
*  备注页面
*/
class TMOrderRemarkView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var bgView = UIImageView(frame: bounds)
        bgView.image = UIImage(named: "remark_bg")
        addSubview(bgView)
        
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
