//
//  TMTakeOrderDetailView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/2/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

class TMTakeOrderDetailView: UIView {
    
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
        
        var discountTitleLabel = UILabel(frame: CGRectMake(16, 24, 60, 18))
        discountTitleLabel.font = UIFont.systemFontOfSize(15.0)
        discountTitleLabel.text = "优惠折扣"
        addSubview(discountTitleLabel)
        
        var discountAmountTitleLabel = UILabel(frame: CGRectMake(16, 68, 60, 18))
        discountAmountTitleLabel.font = UIFont.systemFontOfSize(15.0)
        discountAmountTitleLabel.text = "优惠金额"
        addSubview(discountAmountTitleLabel)
        
        discountAmountLabel = UILabel(frame: CGRectMake(91, 65, 142, 22))
        discountAmountLabel.font = UIFont.systemFontOfSize(18.0)
        discountAmountLabel.textAlignment = .Center
        discountAmountLabel.text = "¥22.00"
        addSubview(discountAmountLabel)
        
        var consumeAmountTitleLabel = UILabel(frame: CGRectMake(260, 25, 60, 18))
        consumeAmountTitleLabel.font = UIFont.systemFontOfSize(15.0)
        consumeAmountTitleLabel.text = "消费金额"
        addSubview(consumeAmountTitleLabel)
        
        consumeAmountLabel = UILabel(frame: CGRectMake(338, 22, 90, 22))
        consumeAmountLabel.font = UIFont.systemFontOfSize(18.0)
        consumeAmountLabel.textAlignment = .Left
        consumeAmountLabel.text = "¥104.00"
        addSubview(consumeAmountLabel)
        
        var actualAmountTitleLabel = UILabel(frame: CGRectMake(260, 67, 60, 18))
        actualAmountTitleLabel.font = UIFont.systemFontOfSize(15.0)
        actualAmountTitleLabel.text = "折后金额"
        addSubview(actualAmountTitleLabel)
        
        actualAmountLabel = UILabel(frame: CGRectMake(338, 65, 90, 22))
        actualAmountLabel.font = UIFont.systemFontOfSize(18.0)
        actualAmountLabel.textColor = UIColor(hex: 0xFF0000)
        actualAmountLabel.textAlignment = .Left
        actualAmountLabel.text = "¥104.00"
        addSubview(actualAmountLabel)
        
        // button
        resetButton = UIButton.buttonWithType(.Custom) as UIButton
        resetButton.frame = CGRectMake(50, 98, 120, 40)
        resetButton.setBackgroundImage(UIImage(named: "baiseanniu"), forState: .Normal)
        resetButton.setBackgroundImage(UIImage(named: "baiseanniu_on"), forState: .Highlighted)
        resetButton.setTitle("重新下单", forState: .Normal)
        resetButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        resetButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(resetButton)
        
        // button
        restingButton = UIButton.buttonWithType(.Custom) as UIButton
        restingButton.frame = CGRectMake(186, 98, 95, 40)
        restingButton.setBackgroundImage(UIImage(named: "baiseanniu"), forState: .Normal)
        restingButton.setBackgroundImage(UIImage(named: "baiseanniu_on"), forState: .Highlighted)
        restingButton.setTitle("挂单", forState: .Normal)
        restingButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        restingButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(restingButton)
        
        // button
        takeOrderButton = UIButton.buttonWithType(.Custom) as UIButton
        takeOrderButton.frame = CGRectMake(297, 98, 120, 40)
        takeOrderButton.setBackgroundImage(UIImage(named: "baiseanniu"), forState: .Normal)
        takeOrderButton.setBackgroundImage(UIImage(named: "baiseanniu_on"), forState: .Highlighted)
        takeOrderButton.setTitle("生成订单", forState: .Normal)
        takeOrderButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        takeOrderButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(takeOrderButton)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
