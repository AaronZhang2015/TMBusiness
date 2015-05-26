//
//  TMProductCell.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/2/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

class TMProductCell: UICollectionViewCell {
    
    var productNameLabel: UILabel!
    var priceLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = UIImageView(image: UIImage(named: "caibg"))
        selectedBackgroundView = UIImageView(image: UIImage(named: "caibg_on"))
        
        productNameLabel = UILabel(frame: CGRectMake(0, 0, bounds.width, bounds.height - 40))
        productNameLabel.numberOfLines = 2
        productNameLabel.font = UIFont.systemFontOfSize(20.0)
        productNameLabel.textAlignment = .Center
        productNameLabel.backgroundColor = UIColor.clearColor()
        productNameLabel.textColor = UIColor.blackColor()
            productNameLabel.highlightedTextColor = UIColor.whiteColor()
        addSubview(productNameLabel)
        
        priceLabel = UILabel(frame: CGRectMake(0, bounds.height - 30, bounds.width, 20))
        priceLabel.numberOfLines = 1
        priceLabel.font = UIFont.systemFontOfSize(20.0)
        priceLabel.textAlignment = .Center
        priceLabel.backgroundColor = UIColor.clearColor()
        priceLabel.textColor = UIColor.blackColor()
        priceLabel.highlightedTextColor = UIColor.whiteColor()
        addSubview(priceLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
