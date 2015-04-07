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
    
    var textView: AZPlaceholderTextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        
        var bgView = UIImageView(frame: bounds)
        bgView.image = UIImage(named: "remark_bg")
        addSubview(bgView)
        
        var topBgView = UIImageView(image: UIImage(named: "remark_top_bg"))
        topBgView.top = 0
        topBgView.width = width
        addSubview(topBgView)
        
        var titleLabel = UILabel(frame: topBgView.bounds)
        titleLabel.font = UIFont.systemFontOfSize(18.0)
        titleLabel.text = "备注"
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        addSubview(titleLabel)
        
        var textViewBg = UIImageView(image: UIImage(named: "remark_content_bg"))
        textViewBg.frame = CGRectMake(10, topBgView.bottom + 10, 380, 186)
        addSubview(textViewBg)
        
        textView = AZPlaceholderTextView(frame: CGRectMake(textViewBg.left + 2, textViewBg.top + 2, textViewBg.width - 4, textViewBg.height - 4))
        textView.placeholder = "请输入备注内容"
        addSubview(textView)
        
        var cancelButton = UIButton.buttonWithType(.Custom) as UIButton
        cancelButton.frame = CGRectMake(72, textViewBg.bottom + 13, 110, 50)
        cancelButton.setBackgroundImage(UIImage(named: "remark_button"), forState: .Normal)
        cancelButton.setBackgroundImage(UIImage(named: "remark_button_on"), forState: .Highlighted)
        cancelButton.setTitle("取消", forState: .Normal)
        //cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(cancelButton)
        
        var commitButton = UIButton.buttonWithType(.Custom) as UIButton
        commitButton.frame = CGRectMake(cancelButton.right + 36, textViewBg.bottom + 13, 110, 50)
        commitButton.setBackgroundImage(UIImage(named: "remark_button"), forState: .Normal)
        commitButton.setBackgroundImage(UIImage(named: "remark_button_on"), forState: .Highlighted)
        commitButton.setTitle("确定", forState: .Normal)
        //commitButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        commitButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(commitButton)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
