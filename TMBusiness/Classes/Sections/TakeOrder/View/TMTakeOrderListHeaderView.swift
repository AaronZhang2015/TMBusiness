//
//  TMTakeOrderListHeaderView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/2/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

class TMTakeOrderListHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        
        var nameLabel = UILabel(frame: CGRectMake(34, 7, 30, 18))
        nameLabel.font = UIFont.systemFontOfSize(15.0)
        nameLabel.text = "名称"
        addSubview(nameLabel)
        
        var quantityLabel = UILabel(frame: CGRectMake(210, 7, 30, 18))
        quantityLabel.font = UIFont.systemFontOfSize(15.0)
        quantityLabel.text = "数量"
        addSubview(quantityLabel)
        
        var priceLabel = UILabel(frame: CGRectMake(324, 7, 30, 18))
        priceLabel.font = UIFont.systemFontOfSize(15.0)
        priceLabel.text = "单价"
        addSubview(priceLabel)
        
        var lineView = UIView(frame: CGRectMake(0, 30, width, 1))
        lineView.backgroundColor = UIColor(hex: 0xD9D9D9)
        addSubview(lineView)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
