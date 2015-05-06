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
    
    // 挂单列表
    var restingOrderDataList = [TMOrder]()
    
    // 待支付列表
    var waitForPayingOrderDataList = [TMOrder]()
    
    // 交易完成列表
    var transactionDoneOrderDataList = [TMOrder]()
    
    // 选中的订单
    var currentSelectedOrder: TMOrder!
    
    lazy var orderDataManager: TMOrderDataManager = {
        return TMOrderDataManager()
        }()
    
    lazy var userDataManager: TMUserDataManager = {
        return TMUserDataManager()
        }()
    
    lazy var menuView: TMOrderMenuView = {
        var view = TMOrderMenuView()
        view.didSelectedIndexClosure = { [weak self] index in
            if let strongSelf = self {
                strongSelf.orderProductListView.hidden = true
                strongSelf.orderListView.data.removeAll(keepCapacity: false)
                strongSelf.orderListView.reloadTableData(true)
                
                if index == 0 {
                    strongSelf.orderListView.status = .Resting
                    strongSelf.fetchRestingOrderList()
                } else if index == 1 {
                    strongSelf.orderListView.status = .WaitForPaying
                    strongSelf.orderListView.orderListTableView.startPullToRefresh()
                } else {
                    strongSelf.orderListView.status = .TransactionDone
                    strongSelf.orderListView.orderListTableView.startPullToRefresh()
                }
            }
        }
        return view
        }()
    
    lazy var orderListView: TMOrderListView = {
        var view = TMOrderListView()
        view.delegate = self
        view.orderListTableView.addPullToRefresh { [weak self] in
            if let strongSelf = self {
                if view.status == .Resting {
                    strongSelf.fetchRestingOrderList()
                } else {
                    strongSelf.fetchOrderList(view.status)
                }
            }
        }
        
        view.orderListTableView.addLoadMoreView { [weak self] in
            if let strongSelf = self {
                
                if view.status == .Resting {
                    strongSelf.fetchRestingOrderList()
                } else {
                    strongSelf.fetchOrderList(view.status, isLoadMore: true)
                }
            }
        }
        
        
        return view
    }()
    
    lazy var orderProductListView: TMOrderProductListView = {
        var view = TMOrderProductListView()
        view.cancelOrderClosure = { [weak self] order in
            // 删除订单
            if let strongSelf = self {
                var alertView = UIAlertView(title: "提示", message: "是否确认取消当前挂单", delegate: strongSelf, cancelButtonTitle: "取消", otherButtonTitles: "确认")
                alertView.tag = 1000
                alertView.show()
            }
        }
        
        view.takeOrderClosure = { [weak self] order in
            if let strongSelf = self {
                var alertView = UIAlertView(title: "提示", message: "是否确认下单", delegate: strongSelf, cancelButtonTitle: "取消", otherButtonTitles: "确认")
                alertView.tag = 1001
                alertView.show()
            }
        }
        
        view.checkoutOrderClosure = { [weak self] order in
            // 转入结账页面
            if let strongSelf = self {
                var masterViewController = strongSelf.parentViewController as! MasterViewController
                masterViewController.handleCheckoutAction(order)
            }
            
        }
        
        view.printOrderClosure = { [weak self] order in
            
        }
        
        return view
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: 0xF5F5F5)
        
        view.addSubview(menuView)
        menuView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(140)
            make.bottom.equalTo(0)
        }
        
        view.addSubview(orderListView)
        orderListView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(menuView.snp_trailing).offset(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(436)
        }
        
        var listContentView = UIView()
        view.addSubview(listContentView)
        listContentView.backgroundColor = UIColor.clearColor()
        listContentView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(orderListView.snp_trailing).offset(-6)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.trailing.equalTo(0)
        }
        
        var separatorView = UIImageView(image: UIImage(named: "checking_account_separator"))
        listContentView.addSubview(separatorView)
        separatorView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(10)
            make.bottom.equalTo(0)
        }

        
        var listBgView = UIView()
        listBgView.backgroundColor = UIColor.whiteColor()
        listContentView.addSubview(listBgView)
        listBgView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(10)
            make.top.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        view.addSubview(orderProductListView)
        orderProductListView.hidden = true
        orderProductListView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(orderListView.snp_trailing).offset(-6)
            make.top.equalTo(0)
            make.bottom.equalTo(-350)
            make.trailing.equalTo(0)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orderListNeedRefresh", name: TMOrderListNeedRefresh, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    func orderListNeedRefresh() {
        orderProductListView.hidden = true
        orderListView.data.removeAll(keepCapacity: false)
        orderListView.reloadTableData(true)
        
        
        if orderListView.status == .Resting {
            fetchRestingOrderList()
        } else {
            orderListView.orderListTableView.startPullToRefresh()
        }
    }
    
    func changeOrderProductListView(order: TMOrder) {
        currentSelectedOrder = order
        orderProductListView.data = currentSelectedOrder
        updateOrderProductListViewFrame()
    }
    
    // MARK: - 更新订单列表详情Frame
    func updateOrderProductListViewFrame() {
        orderProductListView.snp_remakeConstraints { (make) -> Void in
            make.leading.equalTo(orderListView.snp_trailing).offset(-6)
            make.top.equalTo(0)
            make.trailing.equalTo(0)
            
            if let order = currentSelectedOrder where order.product_records.count > 0 {
                println(order.product_records.count)
                var height = (order.product_records.count + 1) * 50
                var delta = height - 350
                
                if delta > 0 {
                    delta = 0
                }
                
                make.bottom.equalTo(delta)
            } else {
                make.bottom.equalTo(-350)
            }
        }
    }
    
    // MARK: - 获取订单列表
    
    /**
    获取订单列表
    
    :param: status     订单状态
    :param: isLoadMore 是否加载更多
    */
    func fetchOrderList(status: TMOrderStatus, isLoadMore: Bool = false) {
        
        var pageIndex = 0
        
        if isLoadMore {
            pageIndex = orderListView.data.count
        }
        
        userDataManager.fetchUserEntityOrderList(TMShop.sharedInstance.shop_id, conditionType: TMConditionType.ShopId, orderStatus: status, orderPageIndex: pageIndex, adminId: TMShop.sharedInstance.admin_id) { [weak self](list, error) -> Void in
            if let strongSelf = self {
                
                // 待支付状态
                if status == .WaitForPaying {
                    
                    if let result = list {
                        // 重新获取
                        if !isLoadMore {
                            // 清空所有数据
                            strongSelf.waitForPayingOrderDataList.removeAll(keepCapacity: false)
                            strongSelf.waitForPayingOrderDataList.extend(result)
                        } else {
                            // 添加数据
                            // 过滤重复数据
                            strongSelf.filterData(&strongSelf.waitForPayingOrderDataList, extendData: result)
                        }
                        
                        strongSelf.orderListView.data = strongSelf.waitForPayingOrderDataList
                    }
                    
                    
                } else {
                    if let result = list {
                        
                        // 重新获取
                        if !isLoadMore {
                            // 清空所有数据
                            strongSelf.transactionDoneOrderDataList.removeAll(keepCapacity: false)
                            strongSelf.transactionDoneOrderDataList.extend(result)
                        } else {
                            // 添加数据
                            // 过滤重复数据
                            strongSelf.filterData(&strongSelf.transactionDoneOrderDataList, extendData: result)
                        }
                        
                        strongSelf.orderListView.data = strongSelf.transactionDoneOrderDataList
                    }
                }
                
                // 刷新数据
                if !isLoadMore {
                    strongSelf.orderListView.orderListTableView.stopPullToRefresh()
                    strongSelf.orderListView.reloadTableData(true)
                } else{
                    strongSelf.orderListView.orderListTableView.stopLoadMore()
                    strongSelf.orderListView.reloadTableData(false)
                }
            }

        }
    }
    
    /**
    获取挂单列表
    */
    func fetchRestingOrderList() {
        restingOrderDataList = orderDataManager.fetchRestingOrderList()
        orderListView.data = restingOrderDataList
        orderListView.reloadTableData(true)
        orderListView.orderListTableView.stopPullToRefresh()
        orderListView.orderListTableView.stopLoadMore()
    }
    
    /**
    获取用户信息以及奖励信息
    */
    func fetchEntityInfoAction(mobileNumber: String, completion: (TMUser -> Void)) {
        startActivity()
        userDataManager.fetchEntityAllInfo(mobileNumber, type: .MobileNumber, shopId: TMShop.sharedInstance.shop_id, businessId: TMShop.sharedInstance.business_id, adminId: TMShop.sharedInstance.admin_id) { [weak self](user, error) -> Void in
            
            if let strongSelf = self {
                strongSelf.stopActivity()
                if error == nil {
                    if let user = user {
                        completion(user)
                        return
                    }
                }
                
                // 获取失败，提示不做操作
            }
            
        }
    }
    
    // MARK: - Helper
    
    func filterData(inout originData: [TMOrder], extendData: [TMOrder]){
        var count = originData.count
        
        for var i = 0; i < extendData.count; ++i {
            var extendOrder = extendData[i]
            
            var find: Bool = false
            for var m = 0; m < count; ++m {
                var originOrder = originData[m]
                
                if originOrder.order_id == extendOrder.order_id {
                    find = true
                    break
                }
            }
            
            if find {
                continue
            } else {
                originData.append(extendOrder)
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
extension TMOrderViewController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            return
        }
        
        if alertView.tag == 1000 {
            orderDataManager.deleteRestingOrder(currentSelectedOrder)
            currentSelectedOrder = nil
            orderProductListView.hidden = true
            fetchRestingOrderList()
        } else if alertView.tag == 1001 {
            // 下单
            currentSelectedOrder.status = TMOrderStatus.WaitForPaying
            
            if currentSelectedOrder.payable_amount.doubleValue > 0 {
                startActivity()
                orderDataManager.addOrderEntityInfo(currentSelectedOrder, completion: { [weak self] (orderId, error) in
                    if let strongSelf = self {
                        strongSelf.stopActivity()
                        // 订单成功
                        if let e = error {
                            
                        } else {
                            // 提交成功
                            strongSelf.orderDataManager.deleteRestingOrder(strongSelf.currentSelectedOrder)
                            strongSelf.currentSelectedOrder = nil
                            strongSelf.orderProductListView.hidden = true
                            strongSelf.fetchRestingOrderList()
                        }
                    }
                    })
            }
        }
    }
}

extension TMOrderViewController: TMOrderListViewDelegate {
    func didSelectedOrder(selectedOrder: TMOrder) {
        changeOrderProductListView(selectedOrder)
        orderProductListView.hidden = false
    }
}
