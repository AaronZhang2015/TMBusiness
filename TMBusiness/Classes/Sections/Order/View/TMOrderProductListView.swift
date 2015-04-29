//
//  TMOrderProductListView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/28/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

class TMOrderProductListView: UIView {

    lazy var separatorView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "checking_account_separator"))
        return imageView
        }()
    
    lazy var bgView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
        }()
    
    lazy var boxImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "order_product_list_bg"))
        return imageView
        }()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        addSubview(separatorView)
        separatorView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(10)
            make.bottom.equalTo(0)
        }
        
        addSubview(bgView)
        bgView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(10)
            make.top.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        addSubview(boxImageView)
        boxImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(17)
            make.leading.equalTo(18)
            make.trailing.equalTo(-9)
            make.bottom.equalTo(-44)
        }
    }
    
}
