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
        
        return view
        }()
    
    lazy var orderListView: TMOrderListView = {
        var view = TMOrderListView()
        view.delegate = self
        view.orderListTableView.addPullToRefresh { [weak self] in
            if let strongSelf = self {
//                strongSelf.fetchOrderList(.WaitForPaying)
                strongSelf.fetchOrderList(.TransactionDone)
            }
        }
        
        view.orderListTableView.addLoadMoreView { [weak self] in
            if let strongSelf = self {
//                strongSelf.fetchOrderList(.WaitForPaying, isLoadMore: true)
                strongSelf.fetchOrderList(.TransactionDone, isLoadMore: true)
            }
        }
        
//        view.didSelectedOrderClosure = {[weak self] order in
//            if let strongSelf = self {
////                strongSelf.fetchOrderList(.WaitForPaying, isLoadMore: true)
//                // TO DO
//                
//            }
//        }
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
        orderProductListView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(orderListView.snp_trailing).offset(-6)
            make.top.equalTo(0)
            make.bottom.equalTo(-390)
            make.trailing.equalTo(0)
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
                var height = order.product_records.count * 50
                var delta = height - 390
                
                if delta > 0 {
                    delta = 0
                }
                
                make.bottom.equalTo(delta)
            } else {
                make.bottom.equalTo(-390)
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
                strongSelf.orderListView.orderListTableView.reloadData()
                if !isLoadMore {
                    strongSelf.orderListView.orderListTableView.stopPullToRefresh()
                } else{
                    strongSelf.orderListView.orderListTableView.stopLoadMore()
                }
            }

        }
    }
    
    /**
    获取挂单列表
    */
    func fetchRestingOrderList() {
        
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
    
}

extension TMOrderViewController: TMOrderListViewDelegate {
    func didSelectedOrder(selectedOrder: TMOrder) {
        changeOrderProductListView(selectedOrder)
    }
}
