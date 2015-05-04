//
//  TMOrderProductDetailView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/30/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

class TMOrderProductDetailView: UIView {
    
    // 优惠折扣
    var discountAmountTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "优惠折扣"
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(20)
        return label
        }()
    
    var discountAmountLabel: UILabel = {
        var label = UILabel()
        label.text = "85折"
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(20)
        return label
        }()
    
    // 消费金额
    var consumeTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "消费金额"
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(20)
        return label
        }()
    
    var consumeLabel: UILabel = {
        var label = UILabel()
        label.text = "¥50.00"
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(20)
        return label
        }()

    // 优惠金额
    var discountTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "优惠金额"
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(20)
        return label
        }()
    
    var discountLabel: UILabel = {
        var label = UILabel()
        label.text = "¥50.00"
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(20)
        return label
        }()
    
    // 折后金额
    var actualTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "折后金额"
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(20)
        return label
        }()
    
    var actualLabel: UILabel = {
        var label = UILabel()
        label.text = "¥138.12"
        label.textColor = UIColor(hex: 0xFF0000)
        label.font = UIFont.systemFontOfSize(20)
        return label
        }()
    
    var dashView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "checking_account_dash_line"))
        return imageView
        }()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        println("init")
        addSubview(discountAmountTitleLabel)
        discountAmountTitleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(10)
            make.top.equalTo(15)
            make.size.equalTo(CGSizeMake(80, 19))
        }
        
        addSubview(discountAmountLabel)
        discountAmountLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(discountAmountTitleLabel.snp_trailing).offset(15)
            make.top.equalTo(15)
            make.size.equalTo(CGSizeMake(100, 19))
        }
        
        addSubview(consumeTitleLabel)
        consumeTitleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(discountAmountLabel.snp_trailing).offset(0)
            make.top.equalTo(15)
            make.size.equalTo(CGSizeMake(80, 19))
        }
        
        addSubview(consumeLabel)
        consumeLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(consumeTitleLabel.snp_trailing).offset(15)
            make.top.equalTo(15)
            make.size.equalTo(CGSizeMake(125, 19))
        }
        
        addSubview(dashView)
        dashView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(50)
            make.height.equalTo(1)
        }
        
        addSubview(discountTitleLabel)
        discountTitleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(10)
            make.top.equalTo(dashView.snp_bottom).offset(15)
            make.size.equalTo(CGSizeMake(80, 19))
        }
        
        addSubview(discountLabel)
        discountLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(discountTitleLabel.snp_trailing).offset(15)
            make.top.equalTo(dashView.snp_bottom).offset(15)
            make.size.equalTo(CGSizeMake(100, 19))
        }
        
        addSubview(actualTitleLabel)
        actualTitleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(discountLabel.snp_trailing).offset(0)
            make.top.equalTo(dashView.snp_bottom).offset(15)
            make.size.equalTo(CGSizeMake(80, 19))
        }
        
        addSubview(actualLabel)
        actualLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(actualTitleLabel.snp_trailing).offset(15)
            make.top.equalTo(dashView.snp_bottom).offset(15)
            make.size.equalTo(CGSizeMake(125, 19))
        }
        
    }
}

