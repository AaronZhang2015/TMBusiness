//
//  CheckingAccountViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/27/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

class TMCheckingAccountViewController: BaseViewController {
    
    lazy var shopDataManager: TMShopDataManager = {
        return TMShopDataManager()
        }()
    
    lazy var checkingAccountHeaderView: TMCheckingAccountSearchView = {
        var view = TMCheckingAccountSearchView()
        view.searchButton.addTarget(self, action: "handleSearchActon", forControlEvents: .TouchUpInside)
        return view
        }()
    
    lazy var amountView: TMCheckingAccountAmountView = {
        return TMCheckingAccountAmountView()
        }()
    
    lazy var detailView: TMCheckingAccountProductListView = {
        return TMCheckingAccountProductListView()
        }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(checkingAccountHeaderView)
        checkingAccountHeaderView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(85)
            make.top.equalTo(0)
        }
        
        view.addSubview(amountView)
        amountView.hidden = true
        amountView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.top.equalTo(checkingAccountHeaderView.snp_bottom)
            make.bottom.equalTo(view.snp_bottom)
            make.width.equalTo(350)
        }
        
        view.addSubview(detailView)
        detailView.hidden = true
        detailView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(amountView.snp_trailing)
            make.top.equalTo(checkingAccountHeaderView.snp_bottom)
            make.bottom.equalTo(view.snp_bottom)
            make.trailing.equalTo(view.snp_trailing)
        }
    }
    
    func handleSearchActon() {
        var startDate: NSDate!
        var endDate: NSDate!
        
        if let startDateString = checkingAccountHeaderView.startDateButton.titleLabel?.text, endDateString = checkingAccountHeaderView.endDateButton.titleLabel?.text {
            startDate = NSDate(fromString: startDateString, format: .Custom("yyyy-MM-dd"))
            endDate = NSDate(fromString: endDateString, format: .Custom("yyyy-MM-dd"))
        } else {
            startDate = NSDate()
            endDate = NSDate()
            checkingAccountHeaderView.startDateButton.setTitle(startDate.toString(format: .Custom("yyyy-MM-dd")), forState: .Normal)
            checkingAccountHeaderView.endDateButton.setTitle(endDate.toString(format: .Custom("yyyy-MM-dd")), forState: .Normal)
        }
        
        startDate = startDate.startDateInDay()
        endDate = endDate.endDateInDay()
        
        println(startDate)
        println(endDate)
        
        startActivity()
        shopDataManager.fetchStatisticsDetail(TMShop.sharedInstance.business_id, shopId: TMShop.sharedInstance.shop_id, startDate: startDate, endDate: endDate, adminId: TMShop.sharedInstance.admin_id) {[weak self] (checkingAccount, error) in
            if let strongSelf = self {
                strongSelf.stopActivity()
                if let e = error {
                    
                } else {
                    strongSelf.amountView.configureData(checkingAccount!)
                    strongSelf.detailView.configureData(checkingAccount!)
                }
            }
        }
        
    }
}
