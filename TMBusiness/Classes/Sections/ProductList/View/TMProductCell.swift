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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = UIImageView(image: UIImage(named: "caibg"))
        selectedBackgroundView = UIImageView(image: UIImage(named: "caibg_on"))
        
        productNameLabel = UILabel(frame: bounds)
        productNameLabel.numberOfLines = 3
        productNameLabel.font = UIFont.systemFontOfSize(15.0)
        productNameLabel.textAlignment = .Center
        productNameLabel.backgroundColor = UIColor.clearColor()
        productNameLabel.textColor = UIColor.blackColor()
            productNameLabel.highlightedTextColor = UIColor.whiteColor()
        addSubview(productNameLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
