//
//  TMTakeOrderDetailView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/2/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

class TMTakeOrderDetailView: UIView {
    
    var discountLabel: UILabel!
    var discountAmountLabel: UILabel!
    var consumeAmountLabel: UILabel!
    var actualAmountLabel: UILabel!
    
    // 优惠选择
    var discountSelectedButton: UIButton!
    
    // 重新下单
    var resetButton: UIButton!
    
    // 挂单
    var restingButton: UIButton!
    
    // 生成订单
    var takeOrderButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var discountTitleLabel = UILabel()//(frame: CGRectMake(16, 24, 60, 18))
        discountTitleLabel.font = UIFont.systemFontOfSize(16.0)
        discountTitleLabel.text = "优惠折扣"
        addSubview(discountTitleLabel)
        discountTitleLabel.snp_makeConstraints { make in
            make.left.equalTo(13)
            make.top.equalTo(19)
            make.width.equalTo(68)
            make.height.equalTo(19)
        }
        
        discountLabel = UILabel()//(frame: CGRectMake(94, 65, 142, 22))
        discountLabel.font = UIFont.systemFontOfSize(18.0)
        discountLabel.textAlignment = .Left
        discountLabel.text = "暂无折扣"
        addSubview(discountLabel)
        discountLabel.snp_makeConstraints { make in
            make.left.equalTo(discountTitleLabel.snp_trailing).with.offset(22)
            make.top.equalTo(discountTitleLabel.snp_top)
            make.height.equalTo(discountTitleLabel.snp_height)
            make.width.greaterThanOrEqualTo(40)
        }
        
        var discountAmountTitleLabel = UILabel()//(frame: CGRectMake(16, 68, 60, 18))
        discountAmountTitleLabel.font = UIFont.systemFontOfSize(16.0)
        discountAmountTitleLabel.text = "优惠金额"
        addSubview(discountAmountTitleLabel)
        discountAmountTitleLabel.snp_makeConstraints { make in
            make.left.equalTo(discountTitleLabel.snp_leading)
            make.top.equalTo(discountTitleLabel.snp_bottom).with.offset(19)
            make.width.equalTo(discountTitleLabel.snp_width)
            make.height.equalTo(discountTitleLabel.snp_height)
        }
        
        discountAmountLabel = UILabel()//(frame: CGRectMake(94, 65, 142, 22))
        discountAmountLabel.font = UIFont.systemFontOfSize(18.0)
        discountAmountLabel.textAlignment = .Left
        discountAmountLabel.text = "¥0.00"
        addSubview(discountAmountLabel)
        discountAmountLabel.snp_makeConstraints { make in
            make.left.equalTo(discountAmountTitleLabel.snp_trailing).with.offset(22)
            make.top.equalTo(discountAmountTitleLabel.snp_top)
            make.height.equalTo(discountAmountTitleLabel.snp_height)
            make.width.greaterThanOrEqualTo(40)
        }
        
        
        var consumeAmountTitleLabel = UILabel()//(frame: CGRectMake(260, 25, 60, 18))
        consumeAmountTitleLabel.font = UIFont.systemFontOfSize(16.0)
        consumeAmountTitleLabel.text = "消费金额"
        addSubview(consumeAmountTitleLabel)
        consumeAmountTitleLabel.snp_makeConstraints { make in
            make.left.equalTo(244)
            make.top.equalTo(discountTitleLabel.snp_top)
            make.width.equalTo(discountTitleLabel.snp_width)
            make.height.equalTo(discountTitleLabel.snp_height)
        }
        
        consumeAmountLabel = UILabel()//(frame: CGRectMake(338, 22, 90, 22))
        consumeAmountLabel.font = UIFont.systemFontOfSize(18.0)
        consumeAmountLabel.textAlignment = .Left
        consumeAmountLabel.text = "¥0.00"
        addSubview(consumeAmountLabel)
        consumeAmountLabel.snp_makeConstraints { make in
            make.left.equalTo(consumeAmountTitleLabel.snp_trailing).with.offset(22)
            make.top.equalTo(consumeAmountTitleLabel.snp_top)
            make.height.equalTo(consumeAmountTitleLabel.snp_height)
            make.width.greaterThanOrEqualTo(40)
        }
        
        
        var actualAmountTitleLabel = UILabel()//(frame: CGRectMake(260, 67, 60, 18))
        actualAmountTitleLabel.font = UIFont.systemFontOfSize(16.0)
        actualAmountTitleLabel.text = "折后金额"
        addSubview(actualAmountTitleLabel)
        actualAmountTitleLabel.snp_makeConstraints { make in
            make.left.equalTo(consumeAmountTitleLabel.snp_leading)
            make.top.equalTo(consumeAmountTitleLabel.snp_bottom).with.offset(19)
            make.width.equalTo(consumeAmountTitleLabel.snp_width)
            make.height.equalTo(consumeAmountTitleLabel.snp_height)
        }
        
        actualAmountLabel = UILabel()//(frame: CGRectMake(338, 65, 90, 22))
        actualAmountLabel.font = UIFont.systemFontOfSize(22.0)
        actualAmountLabel.textColor = UIColor(hex: 0xFF0000)
        actualAmountLabel.textAlignment = .Left
        actualAmountLabel.text = "¥0.00"
        addSubview(actualAmountLabel)
        actualAmountLabel.snp_makeConstraints { make in
            make.left.equalTo(actualAmountTitleLabel.snp_trailing).with.offset(22)
            make.top.equalTo(actualAmountTitleLabel.snp_top).with.offset(-4)
            make.width.greaterThanOrEqualTo(40)
            make.height.equalTo(actualAmountTitleLabel.snp_height).with.offset(4)
        }
        
        
        // button
        resetButton = UIButton.buttonWithType(.Custom) as UIButton
        
        resetButton.titleLabel?.font = UIFont.systemFontOfSize(22.0)
        resetButton.setBackgroundImage(UIImage(named: "home_order"), forState: .Normal)
        resetButton.setBackgroundImage(UIImage(named: "home_order_on"), forState: .Highlighted)
        resetButton.setTitle("重新下单", forState: .Normal)
        resetButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        resetButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(resetButton)
        resetButton.snp_makeConstraints { make in
            make.width.equalTo(131)
            make.height.equalTo(50)
            make.left.equalTo(39)
            make.top.equalTo(discountAmountTitleLabel.snp_bottom).with.offset(18)
        }
        
        
        // button
        restingButton = UIButton.buttonWithType(.Custom) as UIButton
        restingButton.titleLabel?.font = UIFont.systemFontOfSize(22.0)
        restingButton.setBackgroundImage(UIImage(named: "home_order"), forState: .Normal)
        restingButton.setBackgroundImage(UIImage(named: "home_order_on"), forState: .Highlighted)
        restingButton.setTitle("挂单", forState: .Normal)
        restingButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        restingButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(restingButton)
        restingButton.snp_makeConstraints { make in
            make.width.equalTo(106)
            make.height.equalTo(50)
            make.left.equalTo(self.resetButton.snp_trailing).with.offset(10)
            make.top.equalTo(discountAmountTitleLabel.snp_bottom).with.offset(18)
        }
        
        // button
        takeOrderButton = UIButton.buttonWithType(.Custom) as UIButton
        takeOrderButton.titleLabel?.font = UIFont.systemFontOfSize(22.0)
        takeOrderButton.setBackgroundImage(UIImage(named: "home_order"), forState: .Normal)
        takeOrderButton.setBackgroundImage(UIImage(named: "home_order_on"), forState: .Highlighted)
        takeOrderButton.setTitle("生成订单", forState: .Normal)
        takeOrderButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        takeOrderButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(takeOrderButton)
        takeOrderButton.snp_makeConstraints { make in
            make.width.equalTo(131)
            make.height.equalTo(50)
            make.left.equalTo(self.restingButton.snp_trailing).with.offset(10)
            make.top.equalTo(discountAmountTitleLabel.snp_bottom).with.offset(18)
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
