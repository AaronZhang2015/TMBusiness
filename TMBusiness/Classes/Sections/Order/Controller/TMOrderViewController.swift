//
//  TMOrderViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/28/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

class TMOrderViewController: BaseViewController {
    
    lazy var menuView: TMOrderMenuView = {
        var view = TMOrderMenuView()
        
        return view
        }()
    
    lazy var orderListView: TMOrderListView = {
        var view = TMOrderListView()
        return view
    }()
    
    lazy var orderProductListView: TMOrderProductListView = {
        var view = TMOrderProductListView()
        return view
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: 0xF5F5F5)
        
        view.addSubview(menuView)
        menuView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(150)
            make.bottom.equalTo(0)
        }
        
        view.addSubview(orderListView)
        orderListView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(menuView.snp_trailing).offset(-10)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(420)
        }
        
        view.addSubview(orderProductListView)
        orderProductListView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(orderListView.snp_trailing).offset(-10)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.trailing.equalTo(0)
        }
    }
    
}
