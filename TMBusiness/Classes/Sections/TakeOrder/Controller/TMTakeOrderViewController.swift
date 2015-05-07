//
//  TMTakeOrderViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/2/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

let takeOrderListCellReuseIdentifier = "TakeOriderListCell"

let TMOrderListNeedRefresh = "TMOrderListNeedRefresh"

class TMTakeOrderViewController: BaseViewController {
    
    private lazy var shopDataManager: TMShopDataManager = TMShopDataManager()
    
    private lazy var userDataManager: TMUserDataManager = TMUserDataManager()
    
    private lazy var orderDataManager: TMOrderDataManager = TMOrderDataManager()
    
    // 备注操作
    private var remarkButton: UIButton!
    
    // 订单商品列表头
    private var orderListHeaderView: TMTakeOrderListHeaderView!
    
    // 订单商品列表
    private var tableView: UITableView!
    
    // 订单详情页面
    private var orderDetailView: TMTakeOrderDetailView!
    
    // 支付方式页面
    private var orderPayWayView: TMTakeOrderPayWayView!
    
    // 商品列表页面
    private var productListContainerView: UIView!
    
    // 订单
    var order: TMOrder!
    
    // 备注内容
    var orderDescription: String = ""
    
    // 遮罩页面
    private lazy var maskView: UIView = {
        var view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 0
        return view
        }()
    
    // 备注页面
    private lazy var remarkView: TMOrderRemarkView = {
        var remark = TMOrderRemarkView(frame: CGRectMake(0, 0, 405, 300))
        remark.alpha = 0
        remark.orderRemarkViewClosure = { [weak self] index in
            if let strongSelf = self {
                strongSelf.hideRemarkView()
                
                if index == 1 {
                    strongSelf.orderDescription = remark.textView.text
                }
            }
        }
        return remark
        }()
    
    
    // 现金支付页面
    private lazy var cashPayView: TMCashPayView = {
        var payView = TMCashPayView(frame: CGRectZero)
        
        payView.backClosure = { [weak self] in
            
            if let strongSelf = self {
                strongSelf.hideCashPayView(true)
            }
        }
        
        payView.calculateClosure = { [weak self] in
            
            if let strongSelf = self {
                strongSelf.handleCashPayAction()
            }
        }
        
        return payView
        }()
    
    // 会员支付页面
    private lazy var membershipCardPayView: TMMemebershipCardPayView = {
        var payView = TMMemebershipCardPayView(frame: CGRectZero)
        
        payView.backClosure = { [weak self] in
            
            if let strongSelf = self {
                strongSelf.hideMembershipCardPayView(true)
            }
        }
        
        payView.scanClosure = {[weak self] sender in
            if let strongSelf = self {
                // 去扫描二维码
                strongSelf.showCodeScanView()
            }
        }
        
        payView.searchClosure = { [weak self] in
            if let strongSelf = self {
                // 去扫描二维码
                strongSelf.fetchEntityInfoAction()
            }
        }
        
        payView.rechargeButton.addTarget(self, action: "hanldeRechargeAction", forControlEvents: .TouchUpInside)
        payView.consumeButton.addTarget(self, action: "handleConsumeAction", forControlEvents: .TouchUpInside)
//        payView.searchButton.addTarget(self, action: "fetchEntityInfoAction", forControlEvents: .TouchUpInside)
        payView.scanButton.addTarget(self, action: "showCodeScanView", forControlEvents: .TouchUpInside)
        payView.commitButton.addTarget(self, action: "settleBill", forControlEvents: .TouchUpInside)
        return payView
        }()
    
    // 充值页面
    private lazy var rechargeView: TMRechargeView = {
        var rechargeView = TMRechargeView(frame: CGRectMake(0, 0, 375, 470))
        rechargeView.rechargeClosure = { [weak self] (reward) in
            if let strongSelf = self {
                strongSelf.rechargeWithCash()
            }
        }
        return rechargeView
        }()
    
    // 消费记录页面
    private lazy var consumeRecordView: TMConsumeRecordView = {
        var consumeRecordView = TMConsumeRecordView(frame: CGRectMake(0, 0, 452 + 18, 450 + 10))
        
        return consumeRecordView
        }()
    
    // 二维码扫描页面
    private lazy var codeScanView: TMCodeScanView = {
        var codeScanView = TMCodeScanView(frame: CGRectZero)
        codeScanView.backClosure = { [weak self] in
            
            if let strongSelf = self {
                strongSelf.hideCodeScanView(true)
            }
        }
        
        codeScanView.inputClosure = { [weak self] in
            
            if let strongSelf = self {
                strongSelf.hideCodeScanView(true)
            }
        }
        
        codeScanView.decodeQRCodeClosure = { [weak self] code in
            if let strongSelf = self {
                strongSelf.fetchEntityInfoWithQRCodeAction(code)
            }
        }
        
        return codeScanView
    }()

    var editCell: TMTakeOrderListCell?
    var editIndexPath: NSIndexPath?
    
    // 商品列表
    private var data: [TMCategory] = [TMCategory]()
    
    // 点单列表
    private var orderProductList: [TMProduct] = [TMProduct]()
    
    // 点单计算算法
    private lazy var takeOrderCompute: TMTakeOrderCompute = {
        var compute = TMTakeOrderCompute()
        
        self.membershipCardPayView.updateEntityAllInfo(compute)
        self.orderDetailView.updateOrderDetail(compute)
        self.cashPayView.updateEntityAllInfo(compute)
        self.rechargeView.updateRechargeDetail(compute)
        
        compute.refreshDataClosure = { [weak self] compute in
            
            if let strongSelf = self {
                strongSelf.membershipCardPayView.updateEntityAllInfo(compute)
                strongSelf.orderDetailView.updateOrderDetail(compute)
                strongSelf.cashPayView.updateEntityAllInfo(compute)
                strongSelf.rechargeView.updateRechargeDetail(compute)
            }
        
        }
        
        compute.clearAllDataClosure = { [weak self] compute in
            
            if let strongSelf = self {
                strongSelf.membershipCardPayView.updateEntityAllInfo(compute)
                strongSelf.orderDetailView.updateOrderDetail(compute)
                strongSelf.cashPayView.updateEntityAllInfo(compute)
                strongSelf.tableView.reloadData()
            }
            
        }
        
        return compute
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        fetchCategoryList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // 设置所有页面视图
    func configureView() {
        var bgView = UIView(frame: CGRectMake(8, 10, 444, 570))
        bgView.backgroundColor = UIColor.whiteColor()
        view.addSubview(bgView)
        
        var bgImageView = UIImageView(image: UIImage(named: "xiaopiaobg"))
        bgImageView.frame = CGRectMake(0, 0, 444, 570)
        bgView.addSubview(bgImageView)
        
        // 备注按钮
        remarkButton = UIButton.buttonWithType(.Custom) as! UIButton
        remarkButton.frame = CGRectMake(350, 2, 70, 30)
        remarkButton.setImage(UIImage(named: "remark_add"), forState: .Normal)
        remarkButton.setTitle("备注", forState: .Normal)
        remarkButton.titleLabel?.font = UIFont.systemFontOfSize(17.0)
        remarkButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        remarkButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        remarkButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, remarkButton.titleLabel!.width)
        remarkButton.addTarget(self, action: "handleRemarkAction", forControlEvents: .TouchUpInside)
        bgView.addSubview(remarkButton)
        
        var orderContentView = UIView(frame: CGRectMake(5, 34, 434, 365))
        orderContentView.layer.borderWidth = 1
        orderContentView.layer.borderColor = UIColor(hex: 0xD4D4D4).CGColor
        bgView.addSubview(orderContentView)
        
        orderListHeaderView = TMTakeOrderListHeaderView(frame: CGRectMake(0, 0, 434, 31))
        orderContentView.addSubview(orderListHeaderView)
        
        tableView = UITableView(frame: CGRectMake(0, 31, 434, 334))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50.0
        tableView.separatorStyle = .None
        orderContentView.addSubview(tableView)
        
        // Register class
        tableView.registerClass(TMTakeOrderListCell.self, forCellReuseIdentifier: takeOrderListCellReuseIdentifier)
        
        orderDetailView = TMTakeOrderDetailView(frame: CGRectMake(0, 399, 444, 171))
        orderDetailView.resetButton.addTarget(self, action: "handleResetProductList", forControlEvents: .TouchUpInside)
        orderDetailView.restingButton.addTarget(self, action: "handleRestingOrderAction", forControlEvents: .TouchUpInside)
        orderDetailView.takeOrderButton.addTarget(self, action: "addOrderAction", forControlEvents: .TouchUpInside)
        bgView.addSubview(orderDetailView)
        
        orderPayWayView = TMTakeOrderPayWayView(frame: CGRectMake(0, bgView.bottom, 558, view.height - 64 - bgView.bottom))
        orderPayWayView.cashPayButton.addTarget(self, action: "showCashPayView:", forControlEvents: .TouchUpInside)
        orderPayWayView.balancePayButton.addTarget(self, action: "showMembershipCardPayView", forControlEvents: .TouchUpInside)
        view.addSubview(orderPayWayView)
        
        //分割线
        var separatorView = UIImageView(image: UIImage(named: "order_separator"))
        separatorView.frame = CGRectMake(463, 0, 2, view.height - 64)
        view.addSubview(separatorView)
        
        productListContainerView = UIView(frame: CGRectMake(465, 0, 559, view.height - 64))
        view.addSubview(productListContainerView)
        
        // 监听键盘弹出事件
        /*
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        */
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.LandscapeLeft.rawValue & UIInterfaceOrientation.LandscapeRight.rawValue
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! Int
            
            var rect = remarkView.frame
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                rect.top = view.height - keyboardHeight - rect.height
            }
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(duration)
//            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve))
            remarkView.frame = rect
            
            UIView.commitAnimations()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! Int
            
            var rect = remarkView.frame
            rect.center = maskView.center
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(duration)
            //            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve))
            remarkView.frame = rect
            
            UIView.commitAnimations()
        }
    }
    
    // 设置菜单列表
    func configureProductListView() {
        var controllers: [TMProductListViewController] = [TMProductListViewController]()
        
        for var index = 0; index < data.count; ++index {
            var controller = TMProductListViewController()
            controller.delegate = self
            var category = data[index]
            controller.productList = category.products!
            controller.title = category.category_name
            controllers.append(controller)
        }
        
        var containerViewController = AZPagingContainerViewController(controllers: controllers, parentViewController: self)
        
        addChildViewController(containerViewController)
        containerViewController.view.frame = productListContainerView.bounds
        productListContainerView.addSubview(containerViewController.view)
        containerViewController.didMoveToParentViewController(self)
    }
    
    // 加载菜单
    func fetchCategoryList() {
        startActivity()
        shopDataManager.fetchEntityProductList(TMShop.sharedInstance.shop_id!, completion: { [weak self] (list, error) -> Void in
            
            if let strongSelf = self {
                strongSelf.stopActivity()
                if let e = error {
                    
                } else {
                    strongSelf.data = list!
                    strongSelf.configureProductListView()
                }
            }
        
        })
    }
    
    
    // MARK: - Actions
    func handleRemarkAction() {
        showRemarkView()
    }
    
    /**
    显示备注页面
    */
    func showRemarkView() {
        if maskView.superview == nil {
            view.addSubview(maskView)
        }
        
        if remarkView.superview == nil {
            view.addSubview(remarkView)
            remarkView.top = 20
            remarkView.centerX = maskView.centerX
        }
        
        maskView.alpha = 0.4
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.remarkView.alpha = 1.0
        }) { (finished) -> Void in
            self.remarkView.textView.becomeFirstResponder()
            return
        }
        
        remarkView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.remarkView.transform = CGAffineTransformIdentity
        }, completion: nil)
    }
    
    /**
    隐藏备注页面
    */
    func hideRemarkView() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.remarkView.alpha = 0.0
        }) { (finished) -> Void in
            self.maskView.alpha = 0
        }
    }
    
    // MARK: - 充值
    
    /**
    处理充值按钮点击事件
    */
    func hanldeRechargeAction() {
        if let user = takeOrderCompute.user {
            rechargeView.show()
            return
        }
        
        presentInfoAlertView("请输入会员手机号或者扫描会员二维码")
    }
    
    
    // MARK: - 消费记录
    
    /**
    处理消费记录按钮点击事件
    */
    func handleConsumeAction() {
        if let user = takeOrderCompute.user {
            consumeRecordView.show()
            // 加载消费记录数据
            fetchUserOrderList()
            return
        }
        presentInfoAlertView("请输入会员手机号或者扫描会员二维码")
    }
    
    
    /**
    获取用户消费记录
    */
    func fetchUserOrderList() {
        startActivity()
        userDataManager.fetchUserEntityOrder(TMShop.sharedInstance.shop_id, businessId: TMShop.sharedInstance.business_id, type: .Shop, userId: takeOrderCompute.user!.user_id!, startIndex: consumeRecordView.data.count, adminId: TMShop.sharedInstance.admin_id) { [weak self] (list, errir) -> Void in
            
            if let strongSelf = self {
                strongSelf.stopActivity()
                strongSelf.consumeRecordView.updateData(list!)
            }
        }
    }
    
    
    // MARK: - 现金支付页面功能
    /**
    显示现金支付页面
    */
    func showCashPayView(sender: UIButton!) {
        if sender != nil {
            cashPayView.isUserCashPay = false
        }
        
        if cashPayView.superview == nil {
            view.addSubview(cashPayView)
            cashPayView.frame = productListContainerView.frame
            cashPayView.left = view.width
        }
    
        if CGRectEqualToRect(cashPayView.frame, productListContainerView.frame) {
            return
        }
        
        cashPayView.actualLabel.text = "0"
        cashPayView.chargeLabel.text = "0"
        
        var rect = productListContainerView.frame
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.cashPayView.frame = rect
            }) { finished in
                if sender != nil {
                    self.hideMembershipCardPayView(false)
                }
        }
    }
    
    /**
    隐藏现金支付页面
    */
    func hideCashPayView(animated: Bool) {
        if cashPayView.superview == nil {
            return
        }
        
        if !animated {
            cashPayView.removeFromSuperview()
            return
        }
        
        if cashPayView.left >= view.width {
            return
        }
        
        var rect = productListContainerView.frame
        rect.left = view.width
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.cashPayView.frame = rect
            }) {finished in
                self.cashPayView.removeFromSuperview()
        }
    }
    
    // MARK: - 会员支付页面功能
    
    /**
    显示会员支付页面
    */
    func showMembershipCardPayView() {
        if membershipCardPayView.superview == nil {
            view.addSubview(membershipCardPayView)
            membershipCardPayView.frame = productListContainerView.frame
            membershipCardPayView.left = view.width
        }
        
        if CGRectEqualToRect(membershipCardPayView.frame, productListContainerView.frame) {
            return
        }
        
        var rect = productListContainerView.frame
        self.membershipCardPayView.remarkTextView.text = orderDescription
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.membershipCardPayView.frame = rect
            }) { finished in
                self.hideCashPayView(false)
                self.hideCodeScanView(false)
        }
    }
    
    /**
    隐藏会员支付页面
    
    :param: animated 动画是否开启
    */
    func hideMembershipCardPayView(animated: Bool) {
        if membershipCardPayView.superview == nil {
            return
        }
        
        if !animated {
            membershipCardPayView.removeFromSuperview()
            return
        }
        
        if membershipCardPayView.left >= view.width {
            return
        }
        
        var rect = productListContainerView.frame
        rect.left = view.width
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.membershipCardPayView.frame = rect
            }) {finished in
                self.membershipCardPayView.removeFromSuperview()
        }
    }
    
    /**
    获取用户信息以及奖励信息
    */
    func fetchEntityInfoAction() {
        
        var condition = membershipCardPayView.phoneNumberTextField.text
        
//        if count(condition) == 0 {
//            condition = "13770863676"
//        }
        
        if count(condition) == 0 {
            presentInfoAlertView("请输入用户手机号码")
            return
        }
        
        startActivity()
        userDataManager.fetchEntityAllInfo(condition, type: .MobileNumber, shopId: TMShop.sharedInstance.shop_id, businessId: TMShop.sharedInstance.business_id, adminId: TMShop.sharedInstance.admin_id) { [weak self](user, error) -> Void in
            
            if let strongSelf = self {
                strongSelf.stopActivity()
                if error == nil {
                    if let user = user {
                        strongSelf.takeOrderCompute.setUserDetail(user, hasProducts: true)
                        strongSelf.membershipCardPayView.phoneNumberTextField.text = ""
                    }
                }
            }
            
        }
    }
    
    
    /**
    根据二维码获取用户信息
    */
    func fetchEntityInfoWithQRCodeAction(code: String) {
        if count(code) > 0 {
            startActivity()
            userDataManager.fetchEntityAllInfo(code, type: .UserId, shopId: TMShop.sharedInstance.shop_id, businessId: TMShop.sharedInstance.business_id, adminId: TMShop.sharedInstance.admin_id, isEncrypt: true) { [weak self](user, error) -> Void in
                
                if let strongSelf = self {
                    strongSelf.stopActivity()
                    if error == nil {
                        if let user = user {
                            user.isScan = true
                            strongSelf.takeOrderCompute.setUserDetail(user, hasProducts: true)
                        }
                        strongSelf.hideCodeScanView(true)
                        strongSelf.membershipCardPayView.phoneNumberTextField.text = ""
                    } else {
                        strongSelf.codeScanView.canScan = true
                    }
                }
                
            }
        }
    }
    
     /**
    结账
    */
    func settleBill() {
        
        if let user = takeOrderCompute.user {

            if membershipCardPayView.getSelectedCount() == 0 {
                presentInfoAlertView("请先选择支付方式")
                return
            }
            
            // 判断当前支付方式，如果是包含现金支付，并且现金确实需要额外支付
            // 那么跳转到现金支付页面，进行操作
            
            if !takeOrderCompute.isWaitForPaying {
                order = takeOrderCompute.getOrder(membershipCardPayView.remarkTextView.text)
            }
            
            var transactionMode = takeOrderCompute.getTransactionMode()
            if transactionMode == .Cash || transactionMode == .CashAndBalance {
                if takeOrderCompute.getActualAmount() - takeOrderCompute.getUserBalance().doubleValue > 0 {
                    cashPayView.isUserCashPay = true
                    cashPayView.updateEntityAllInfo(takeOrderCompute)
                    showCashPayView(nil)
                    return
                } else {
                    order.transaction_mode = .Balance
                }
            }
            
            // 如果是未支付订单结账，则删除之前订单
            if takeOrderCompute.isWaitForPaying && order.payable_amount.doubleValue > 0 {
                updateOrder()
                
                return
            }
            
            if order.payable_amount.doubleValue > 0 {
                startActivity()
                orderDataManager.addOrderEntityInfo(order, completion: { [weak self] (orderId, error) in
                    if let strongSelf = self {
                        strongSelf.stopActivity()
                        // 订单成功
                        if let e = error {
                            // 提示错误
                            var alert = UIAlertView(title: "提示", message: "支付提交失败，是否转为挂单", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "挂单")
                            alert.show()
                        } else {
                            // 提示操作成功
                            strongSelf.hideMembershipCardPayView(true)
                            
                            if strongSelf.takeOrderCompute.isRestingOrder && strongSelf.takeOrderCompute.orderIndex != nil {
                                // 删除挂单数据
                                strongSelf.orderDataManager.deleteRestingOrder(strongSelf.order)
                                NSNotificationCenter.defaultCenter().postNotificationName(TMOrderListNeedRefresh, object: nil)
                            }
                            // 清空之前用户数据
                            strongSelf.takeOrderCompute.clearAllData()
                            strongSelf.presentInfoAlertView("支付成功")
                        }
                    }
                    })
            } else {
                presentInfoAlertView("请选择商品")
            }

        } else {
            presentInfoAlertView("请输入会员手机号或者扫描会员二维码")
        }
    }
    
    // MARK: - 订单操作
    
    // 重新下单
    func handleResetProductList() {
        var alertView = UIAlertView(title: "提示", message: "是否确定清空当前已点商品信息", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.tag = 1000
        alertView.show()
    }
    
    // 挂单操作
    func handleRestingOrderAction() {
        var order = takeOrderCompute.getOrder(membershipCardPayView.remarkTextView.text)
        
        if order.payable_amount.doubleValue > 0 {
            order.status = .Resting
            order.order_index = "\(NSDate().timeIntervalSince1970)"
            orderDataManager.cacheRestingOrder(order)
            // 清空之前用户数据
            takeOrderCompute.clearAllData()
            presentInfoAlertView("挂单成功")
        }
    }
    
    // 生成订单
    func addOrderAction() {
        var order = takeOrderCompute.getOrder(membershipCardPayView.remarkTextView.text)
        order.status = TMOrderStatus.WaitForPaying
        
        if order.payable_amount.doubleValue > 0 {
            startActivity()
            orderDataManager.addOrderEntityInfo(order, completion: { [weak self] (orderId, error) in
                if let strongSelf = self {
                    strongSelf.stopActivity()
                    // 订单成功
                    if let e = error {
                        // 提示错误
                        var alert = UIAlertView(title: "提示", message: "生成订单提交失败，是否转为挂单", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "挂单")
                        alert.show()
                    } else {
                        // 清空之前用户数据
                        strongSelf.takeOrderCompute.clearAllData()
                        strongSelf.presentInfoAlertView("下单成功")
                    }
                }
                })
        } else {
            presentInfoAlertView("请选择商品")
        }
    }
    
    
    // MARK: - 二维码扫描
    func showCodeScanView() {
        codeScanView.canScan = true
        if codeScanView.superview == nil {
            view.addSubview(codeScanView)
            codeScanView.frame = productListContainerView.frame
            codeScanView.left = view.width
        }
        
        if CGRectEqualToRect(codeScanView.frame, productListContainerView.frame) {
            return
        }
        
        var rect = productListContainerView.frame
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.codeScanView.frame = rect
            }) { finished in
//                self.hideMembershipCardPayView(false)
        }
    }
    
    
    /**
    隐藏二维码扫描页面
    
    :param: animated 是否有动画
    */
    func hideCodeScanView(animated: Bool) {
        if codeScanView.superview == nil {
            return
        }
        
        if !animated {
            codeScanView.removeFromSuperview()
            return
        }
        
        if codeScanView.left >= view.width {
            return
        }
        
        var rect = productListContainerView.frame
        rect.left = view.width
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.codeScanView.frame = rect
            }) {finished in
                self.codeScanView.removeFromSuperview()
        }
    }
    
    /**
    现金充值
    */
    func rechargeWithCash() {
        var reward = rechargeView.data[rechargeView.currentSelectedIndex]
        if let user_id = takeOrderCompute.user?.user_id, reward_id = reward.reward_id, current_number_max = reward.current_number_max {
            var reward_number = reward.reward_description?.toNumber
            
            var totalAmount = current_number_max.integerValue
            if let reward_number = reward.reward_description?.toNumber {
                totalAmount += reward_number.integerValue
            }
            
            startActivity()
            userDataManager.doUserRechargeWithCash(userId: user_id, rewardId: reward_id, totalAmount: NSNumber(integer: totalAmount), actualAmount: current_number_max, actualType: .Cash, shopId: TMShop.sharedInstance.shop_id, businessId: TMShop.sharedInstance.business_id, adminId: TMShop.sharedInstance.admin_id, completion: { [weak self] (error) -> Void in
                
                if let strongSelf = self {
                    if let e = error {
                        strongSelf.stopActivity()
                    } else {
                        // 充值成功
                        // 刷新用户数据
                        strongSelf.userDataManager.fetchEntityAllInfo(user_id, type: TMConditionType.UserId, shopId: TMShop.sharedInstance.shop_id, businessId: TMShop.sharedInstance.business_id, adminId: TMShop.sharedInstance.admin_id, completion: { (user, error) -> Void in
                            strongSelf.stopActivity()
                            if error == nil {
                                if let user = user {
                                    
                                    if let oldUser = strongSelf.takeOrderCompute.user {
                                        user.isScan = oldUser.isScan
                                    }
                                    
                                    strongSelf.takeOrderCompute.setUserDetail(user, hasProducts: true)
                                }
                                strongSelf.presentInfoAlertView("充值成功")
                            }
                            
                        })
                    }
                }
                })
        }
    }
    
    
    // MARK: - 现金支付页面
    func handleCashPayAction() {
        
        if let actualAmount = cashPayView.actualLabel.text?.toNumber?.doubleValue {
            
            if cashPayView.isUserCashPay {
                if actualAmount < takeOrderCompute.getActualCashAmount() {
                    presentInfoAlertView("顾客支付金额不足")
                    return
                }
            } else {
                if actualAmount < takeOrderCompute.getActualAmount() {
                    presentInfoAlertView("顾客支付金额不足")
                    return
                }
                
            }
            
            // 如果是未支付订单结账，则删除之前订单
            if takeOrderCompute.isWaitForPaying && order.payable_amount.doubleValue > 0 {
                updateOrder()
                
                return
            }
    
            order = takeOrderCompute.getOrder(orderDescription)
        
            if order.payable_amount.doubleValue > 0 {
                startActivity()
                orderDataManager.addOrderEntityInfo(order, completion: { [weak self] (orderId, error) in
                    if let strongSelf = self {
                        strongSelf.stopActivity()
                        // 订单成功
                        if let e = error {
                            // 提示错误
                            var alert = UIAlertView(title: "提示", message: "支付提交失败，是否转为挂单", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "挂单")
                            alert.show()
                        } else {
                            // 提示操作成功
                            strongSelf.hideCashPayView(true)
                            strongSelf.hideMembershipCardPayView(false)
                            // 清空之前用户数据
                            
                            if strongSelf.takeOrderCompute.isRestingOrder && strongSelf.takeOrderCompute.orderIndex != nil {
                                // 删除挂单数据
                                strongSelf.orderDataManager.deleteRestingOrder(strongSelf.order)
                                NSNotificationCenter.defaultCenter().postNotificationName(TMOrderListNeedRefresh, object: nil)
                            }
                            
                            strongSelf.takeOrderCompute.clearAllData()
                            strongSelf.presentInfoAlertView("支付成功")
                        }
                    }
                    })
            } else {
                // 请选择商品
                presentInfoAlertView("请选择商品")
            }
        }
    }
    
    /**
    加载订单信息
    
    :param: order 订单
    :param: user  用户信息
    */
    func loadFromOrderList(order: TMOrder) {
        takeOrderCompute.clearAllData()
        // 设置商品列表
        // 获取商品列表
        for record in order.product_records {
            if let product = shopDataManager.fetchProduct(record.product_id!) {
                takeOrderCompute.addProduct(product)
            }
        }
        
        if let order_id = order.order_id {
            takeOrderCompute.isWaitForPaying = true
            takeOrderCompute.isRestingOrder = false
        } else {
            takeOrderCompute.isWaitForPaying = false
            takeOrderCompute.isRestingOrder = true
            takeOrderCompute.orderIndex = order.order_index
        }
        
        self.order = order
        tableView.reloadData()
    }
    
    func updateOrder() {
        // 更新订单状态
        order.status = TMOrderStatus.Invalid
        order.business_id = TMShop.sharedInstance.business_id
        order.admin_id = TMShop.sharedInstance.admin_id
        startActivity()
        orderDataManager.updateOrderStatus(order) { [weak self] success in
            if let strongSelf = self {
                // 重新创建订单
                if success {
                    strongSelf.order = strongSelf.takeOrderCompute.getOrder(strongSelf.orderDescription)
                    strongSelf.orderDataManager.addOrderEntityInfo(strongSelf.order, completion: { [weak self] (orderId, error) in
                        if let strongSelf = self {
                            strongSelf.stopActivity()
                            // 订单成功
                            if let e = error {
                                // 提示错误
                                var alert = UIAlertView(title: "提示", message: "支付提交失败", delegate: nil, cancelButtonTitle: "确定")
                                alert.show()
                            } else {
                                // 提示操作成功
                                strongSelf.hideCashPayView(true)
                                strongSelf.hideMembershipCardPayView(false)
                                // 清空之前用户数据
                                strongSelf.takeOrderCompute.clearAllData()
                                strongSelf.presentInfoAlertView("支付成功")
                                NSNotificationCenter.defaultCenter().postNotificationName(TMOrderListNeedRefresh, object: nil)
                            }
                        }
                        })
                } else {
                    strongSelf.stopActivity()
                }
            }
        }
    }
}


// MARK: - UITableViewDelegate
extension TMTakeOrderViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let editIndexPath = editIndexPath {
            if editIndexPath != indexPath {
                let cell = tableView.cellForRowAtIndexPath(editIndexPath) as! TMTakeOrderListCell
                cell.editOrderData(false)
            } else{
                return
            }
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TMTakeOrderListCell
        cell.editOrderData(true)
        editIndexPath = indexPath
        editCell = cell
    }
}

// MARK: - UITableViewDataSource
extension TMTakeOrderViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return takeOrderCompute.getProducts().count//orderProductList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(takeOrderListCellReuseIdentifier, forIndexPath: indexPath) as! TMTakeOrderListCell
        cell.delegate = self
        cell.configureData(takeOrderCompute.getProducts()[indexPath.row])
        
        if let editIndexPath = self.editIndexPath {
            if editIndexPath.row == indexPath.row && editIndexPath.section == editIndexPath.section {
                cell.editOrderData(true)
            }
        }
        
        return cell
    }
}

// MARK: - TMTakeOrderListCellDelegate

extension TMTakeOrderViewController: TMTakeOrderListCellDelegate {
    func orderListDidDelete(product: TMProduct) {
        
        var (success, index) = takeOrderCompute.deleteProduct(product)
        
        if success {
            editCell = nil
            editIndexPath = nil
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left)
            tableView.endUpdates()
        }
    }
    
    func orderListDidSubtract(product: TMProduct) {
        
        var (success, index) = takeOrderCompute.subtractProduct(product)
        
        if success {
            if index == -1 {
                editCell = nil
                editIndexPath = nil
                tableView.reloadData()
            } else {
                tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
                tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: false, scrollPosition: .None)
            }
        }
    }
    
    func orderListDidPlus(product: TMProduct) {
        var index = takeOrderCompute.addProduct(product)
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: false, scrollPosition: .None)
    }
}

// MARK: - 点击菜品

extension TMTakeOrderViewController: TMProductListViewControllerDelegate {
    
    func productListViewController(viewController: TMProductListViewController, didSelectedProduct: TMProduct) {
        
        var index = takeOrderCompute.addProduct(didSelectedProduct)
        
        tableView.reloadData()
        if editIndexPath != nil {
            tableView.selectRowAtIndexPath(editIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
        }
        
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }
}

extension TMTakeOrderViewController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            
            if alertView.tag == 1000 {
                takeOrderCompute.clearAllData()
            } else {
                // 采取挂单
                if let order = self.order {
                    orderDataManager.cacheRestingOrder(order)
                    // 清空之前用户数据
                    takeOrderCompute.clearAllData()
                }
            }
        }
    }
}
