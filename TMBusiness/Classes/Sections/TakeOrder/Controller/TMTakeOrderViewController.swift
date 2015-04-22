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

class TMTakeOrderViewController: BaseViewController {
    
    private lazy var shopDataManager: TMShopDataManager = {
        return TMShopDataManager()
        }()
    
    private lazy var userDataManager: TMUserDataManager = TMUserDataManager()
    
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
        
        payView.calculateClosure = {
            
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
        
        payView.rechargeButton.addTarget(self, action: "hanldeRechargeAction", forControlEvents: .TouchUpInside)
        payView.consumeButton.addTarget(self, action: "showConsumeRecordView", forControlEvents: .TouchUpInside)
        payView.searchButton.addTarget(self, action: "fetchEntityInfoAction", forControlEvents: .TouchUpInside)
        payView.scanButton.addTarget(self, action: "showCodeScanView", forControlEvents: .TouchUpInside)
        
        return payView
        }()
    
    // 充值页面
    private lazy var rechargeView: TMRechargeView = {
        var rechargeView = TMRechargeView(frame: CGRectMake(0, 0, 375, 470))
        rechargeView.cancelButton.addTarget(self, action: "hideRechargeView", forControlEvents: .TouchUpInside)
//        rechargeView.cashButton.addTarget(self, action: "handleRechargeWithCashAction", forControlEvents: .TouchUpInside)
        return rechargeView
        }()
    
    // 消费记录页面
    private lazy var consumeRecordView: TMConsumeRecordView = {
        var consumeRecordView = TMConsumeRecordView(frame: CGRectMake(0, 0, 452, 450))
        
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
        bgView.addSubview(orderDetailView)
        
        orderPayWayView = TMTakeOrderPayWayView(frame: CGRectMake(0, bgView.bottom, 558, view.height - 64 - bgView.bottom))
        orderPayWayView.cashPayButton.addTarget(self, action: "showCashPayView", forControlEvents: .TouchUpInside)
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
        shopDataManager.fetchEntityProductList(TMShop.sharedInstance.shop_id!, completion: { (list, error) -> Void in
            if let e = error {
                
            } else {
                self.data = list!
                self.configureProductListView()
            }
        })
    }
    
    
    // MARK: - 点单按钮事件
    func handleResetProductList() {
        takeOrderCompute.clearAllData()
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
    
    // MARK: -
    func hanldeRechargeAction() {
        if let user = takeOrderCompute.user {
            showRechargeView()
            return
        }
        
        presentInfoAlertView("请先查询用户信息")
    }
    
    /**
    显示充值页面
    */
    func showRechargeView() {
        if maskView.superview == nil {
            view.addSubview(maskView)
        }
        
        if rechargeView.superview == nil {
            view.addSubview(rechargeView)
            rechargeView.center = maskView.center
        }
        
        maskView.alpha = 0.4
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.rechargeView.alpha = 1.0
            }) { (finished) -> Void in
                return
        }
        
        remarkView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.rechargeView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    /**
    隐藏充值页面
    */
    func hideRechargeView() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.rechargeView.alpha = 0.0
            }) { (finished) -> Void in
                self.maskView.alpha = 0
        }
    }
    
    /**
    显示消费记录页面
    */
    func showConsumeRecordView() {
        if maskView.superview == nil {
            view.addSubview(maskView)
        }
        
        if consumeRecordView.superview == nil {
            view.addSubview(consumeRecordView)
            consumeRecordView.center = maskView.center
        }
        
        maskView.alpha = 0.4
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.consumeRecordView.alpha = 1.0
            }) { (finished) -> Void in
                return
        }
        
        consumeRecordView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.consumeRecordView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    /**
    隐藏消费记录页面
    */
    func hideConsumeRecordVIew() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.consumeRecordView.alpha = 0.0
            }) { (finished) -> Void in
                self.maskView.alpha = 0
        }
    }
    
    /**
    显示现金支付页面
    */
    func showCashPayView() {
        if cashPayView.superview == nil {
            view.addSubview(cashPayView)
            cashPayView.frame = productListContainerView.frame
            cashPayView.left = view.width
        }
    
        if CGRectEqualToRect(cashPayView.frame, productListContainerView.frame) {
            return
        }
        
        var rect = productListContainerView.frame
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.cashPayView.frame = rect
            }) { finished in
                self.hideMembershipCardPayView(false)
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
        
        if count(condition) == 0 {
            condition = "13770863676"
        }

        userDataManager.fetchEntityAllInfo(condition, type: .MobileNumber, shopId: TMShop.sharedInstance.shop_id, businessId: TMShop.sharedInstance.business_id, adminId: TMShop.sharedInstance.admin_id) { (user, error) -> Void in
            
            if error == nil {
                if let user = user {
                    self.takeOrderCompute.setUserDetail(user, hasProducts: true)
                }
            }
        }
    }
    
    
    // MARK: - 二维码扫描
    func showCodeScanView() {
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
    func handleRechargeWithCashAction() {
        
//        var alertView = UIAlertView(title: "充值提示", message: "", delegate: <#UIAlertViewDelegate?#>, cancelButtonTitle: <#String?#>, otherButtonTitles: <#String#>, <#moreButtonTitles: String#>...))
        
//        return
        var reward = rechargeView.data[rechargeView.currentSelectedIndex]
        if let user_id = takeOrderCompute.user?.user_id, reward_id = reward.reward_id, current_number_max = reward.current_number_max {
            var reward_number = reward.reward_description?.toNumber
            
            var totalAmount = current_number_max.integerValue
            if let reward_number = reward.reward_description?.toNumber {
                totalAmount += reward_number.integerValue
            }
            
            userDataManager.doUserRechargeWithCash(userId: user_id, rewardId: reward_id, totalAmount: NSNumber(integer: totalAmount), actualAmount: current_number_max, actualType: .Cash, shopId: TMShop.sharedInstance.shop_id, businessId: TMShop.sharedInstance.business_id, adminId: TMShop.sharedInstance.admin_id, completion: { [weak self] (error) -> Void in
                
                // 充值出错
                if let e = error {
                    
                } else {
                    // 充值成功
                    // 刷新用户数据
                    if let strongSelf = self {
                        strongSelf.userDataManager.fetchEntityAllInfo(user_id, type: TMConditionType.UserId, shopId: TMShop.sharedInstance.shop_id, businessId: TMShop.sharedInstance.business_id, adminId: TMShop.sharedInstance.admin_id, completion: { (user, error) -> Void in
                            
                            if error == nil {
                                if let user = user {
                                    strongSelf.takeOrderCompute.setUserDetail(user, hasProducts: true)
                                }
                            }
                            
                        })
                    }
                }
            })
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
