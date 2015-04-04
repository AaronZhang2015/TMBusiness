//
//  TMLoginHeaderView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/2/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

class TMLoginHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var topImageView = UIImageView(image: UIImage(named: "login_topbg"))
        topImageView.top = 0
        addSubview(topImageView)
        
        var logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.top = 50
        logoImageView.centerX = centerX
        addSubview(logoImageView)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
