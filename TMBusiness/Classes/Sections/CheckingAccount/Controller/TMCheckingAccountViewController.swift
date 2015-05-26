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
    
    var startDate: NSDate!
    var endDate: NSDate!
    var checkingAccount: TMCheckingAccount?
    
    lazy var shopDataManager: TMShopDataManager = {
        return TMShopDataManager()
        }()
    
    private lazy var printerManager: TMPrinterManager = {
        var manager = TMPrinterManager.sharedInstance
        manager.failedClosure = {[weak self] in
            if let strongSelf = self {
                strongSelf.showMessage("请去系统设置里面配置打印机ip地址")
            }
        }
        return manager
        }()
    
    lazy var checkingAccountHeaderView: TMCheckingAccountSearchView = {
        var view = TMCheckingAccountSearchView()
        view.searchButton.addTarget(self, action: "handleSearchActon", forControlEvents: .TouchUpInside)
        view.printButton.addTarget(self, action: "handlePrintActon", forControlEvents: .TouchUpInside)
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
        
        var now = NSDate()
        
        if let startDateString = checkingAccountHeaderView.startDateButton.titleLabel?.text, endDateString = checkingAccountHeaderView.endDateButton.titleLabel?.text {
            startDate = NSDate(fromString: startDateString, format: .Custom("yyyy-MM-dd"))
            endDate = NSDate(fromString: endDateString, format: .Custom("yyyy-MM-dd"))
            
            // 如果截止时间和今天是同一天
            if endDateString == now.toString(format: .Custom("yyyy-MM-dd")) {
                endDate = now
            }
        } else {
            startDate = NSDate()
            endDate = NSDate()
            checkingAccountHeaderView.startDateButton.setTitle(startDate.toString(format: .Custom("yyyy-MM-dd")), forState: .Normal)
            checkingAccountHeaderView.endDateButton.setTitle(endDate.toString(format: .Custom("yyyy-MM-dd")), forState: .Normal)
        }
        
//        self.startDate = startDate//.startDateInDay()
//        self.endDate = endDate//.startDateInDay()
        
        startActivity()
        shopDataManager.fetchStatisticsDetail(TMShop.sharedInstance.business_id, shopId: TMShop.sharedInstance.shop_id, startDate: startDate.startDateInDay(), endDate: endDate.startDateInDay(), adminId: TMShop.sharedInstance.admin_id) {[weak self] (checkingAccount, error) in
            if let strongSelf = self {
                strongSelf.stopActivity()
                strongSelf.checkingAccount = checkingAccount
                if let e = error {
                    strongSelf.showMessage("查询失败")
                } else {
                    strongSelf.amountView.configureData(checkingAccount!)
                    strongSelf.detailView.configureData(checkingAccount!)
                }
            }
        }
    }
    
    func handlePrintActon() {
        
        var IPKey = "\(TMShop.sharedInstance.shop_id)_IP"
        if let value = NSUserDefaults.standardUserDefaults().stringForKey(IPKey) {
            printerManager.ipAddress = value
        } else {
            showMessage("请去系统设置里面配置打印机ip地址")
            return
        }
        
        if let checkingAccount = checkingAccount, startDate = startDate, endDate = endDate {
            TMPrinterManager.sharedInstance.printCheckingAccount(checkingAccount, shop: TMShop.sharedInstance, startDate: startDate.startDateInDay(), endDate: endDate)
        } else {
            showMessage("请先进行查询")
        }
    }
}
