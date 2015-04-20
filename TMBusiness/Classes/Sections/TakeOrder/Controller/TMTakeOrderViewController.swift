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
        remark.orderRemarkViewClosure = { index in
            self.hideRemarkView()
        }
        return remark
        }()
    
    
    // 现金支付页面
    private lazy var cashPayView: TMCashPayView = {
        var payView = TMCashPayView(frame: CGRectZero)
        
        payView.backClosure = {
            self.hideCashPayView(true)
        }
        
        payView.calculateClosure = {
            
        }
        
        return payView
        }()
    
    // 会员支付页面
    private lazy var membershipCardPayView: TMMemebershipCardPayView = {
        var payView = TMMemebershipCardPayView(frame: CGRectZero)
        
        payView.backClosure = {
            self.hideMembershipCardPayView(true)
        }
        
        payView.rechargeButton.addTarget(self, action: "showRechargeView", forControlEvents: .TouchUpInside)
        payView.consumeButton.addTarget(self, action: "showConsumeRecordView", forControlEvents: .TouchUpInside)
        payView.searchButton.addTarget(self, action: "fetchEntityInfoAction", forControlEvents: .TouchUpInside)
        
        return payView
        }()
    
    // 充值页面
    private lazy var rechargeView: TMRechargeView = {
        var rechargeView = TMRechargeView(frame: CGRectMake(0, 0, 375, 470))
        
        return rechargeView
        }()
    
    // 消费记录页面
    private lazy var consumeRecordView: TMConsumeRecordView = {
        var consumeRecordView = TMConsumeRecordView(frame: CGRectMake(0, 0, 452, 450))
        
        return consumeRecordView
        }()
    
    var editCell: TMTakeOrderListCell?
    var editIndexPath: NSIndexPath?
    
    // 商品列表
    private var data: [TMCategory] = [TMCategory]()
    
    // 点单列表
    private var orderProductList: [TMProduct] = [TMProduct]()
    
    // 点单计算算法
    private var takeOrderCompute: TMTakeOrderCompute = TMTakeOrderCompute()

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
    
    /**
    更新价格之类的详情
    */
    func updateOrderDetail() {
        var totalPrice: Double = 0.00
        var discountPrice: Double = 0.00
        var actualPrice: Double = 0.00
        for var index = 0; index < orderProductList.count; ++index {
            var product = orderProductList[index]
            totalPrice += product.official_quotation.doubleValue * product.quantity.doubleValue
        }
        
        let format = ".2"
        // 更新价格
        
        // 消费金额
        orderDetailView.consumeAmountLabel.text = "¥\(totalPrice.format(format))"
        
        // 优惠金额
        
        
        // 折后金额
        actualPrice = totalPrice - discountPrice
        orderDetailView.actualAmountLabel.text = "¥\(actualPrice.format(format))"
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
    
    func fetchEntityInfoAction() {
        
        var condition = membershipCardPayView.phoneNumberTextField.text
        condition = "13770863676"

        userDataManager.fetchEntityAllInfo(condition, type: .MobileNumber, shopId: TMShop.sharedInstance.shop_id, businessId: TMShop.sharedInstance.business_id, adminId: TMShop.sharedInstance.admin_id) { (user, error) -> Void in
            
        }
        
//        TMUserService().fetchEntityAllInfo("18851618829", type: .MobileNumber, shopId: TMShop.sharedInstance.shop_id!, businessId: TMShop.sharedInstance.business_id!, adminId: TMShop.sharedInstance.admin_id!)
        
//        userDataManager.fetchEntityAllInfo.fetchEntityAllInfo("13770863676", type: .MobileNumber, shopId: TMShop.sharedInstance.shop_id!, businessId: TMShop.sharedInstance.business_id!, adminId: TMShop.sharedInstance.admin_id!)
    }
}


// MARK: - UITableViewDelegate
extension TMTakeOrderViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelectRowAtIndexPath")
        if editCell != nil {
            if editIndexPath != nil {
                if editIndexPath != indexPath {
                    editCell!.editOrderData(false)
                } else {
                    return
                }
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
        
        updateOrderDetail()
        
        tableView.reloadData()
        if editIndexPath != nil {
            tableView.selectRowAtIndexPath(editIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
        }
        
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }
}
