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
        payView.backButton.addTarget(self, action: "hideCashPayView", forControlEvents: .TouchUpInside)
        return payView
        }()
    
    var editCell: TMTakeOrderListCell?
    var editIndexPath: NSIndexPath?
    
    // 商品列表
    private var data: [TMCategory] = [TMCategory]()
    
    // 点单列表
    private var orderProductList: [TMProduct] = [TMProduct]()

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
        remarkButton = UIButton.buttonWithType(.Custom) as UIButton
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
        view.addSubview(orderPayWayView)
        
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
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as Double
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as Int
            
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
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as Double
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as Int
            
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
        var totalPrice: NSNumber = 0.00
        for var index = 0; index < orderProductList.count; ++index {
            var product = orderProductList[index]
            var price = product.official_quotation.doubleValue * product.quantity.doubleValue + totalPrice.doubleValue
            totalPrice = NSNumber(double: price)
        }
        
        // 更新价格
        orderDetailView.consumeAmountLabel.text = NSString(format: "%.2f", totalPrice.doubleValue)
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
        }, completion: nil)
    }
    
    /**
    隐藏现金支付页面
    */
    func hideCashPayView() {
        if cashPayView.superview == nil {
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
}

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
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as TMTakeOrderListCell
        cell.editOrderData(true)
        editIndexPath = indexPath
        editCell = cell
    }
}

extension TMTakeOrderViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderProductList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(takeOrderListCellReuseIdentifier, forIndexPath: indexPath) as TMTakeOrderListCell
        cell.delegate = self
        cell.configureData(orderProductList[indexPath.row])
        
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
        
        var index = 0
        for ; index < orderProductList.count; ++index {
            if orderProductList[index] == product {
                break
            }
        }
        
        orderProductList.removeAtIndex(index)
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([editIndexPath!], withRowAnimation: UITableViewRowAnimation.Left)
        tableView.endUpdates()
        
        editCell = nil
        editIndexPath = nil
        updateOrderDetail()
    }
    
    func orderListDidSubtract(product: TMProduct) {
        var quantity = product.quantity.integerValue - 1
        
        if quantity < 1 {
            quantity = 1
        }
        
        product.quantity = NSNumber(integer: quantity)
        tableView.reloadRowsAtIndexPaths([editIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
        tableView.selectRowAtIndexPath(editIndexPath, animated: false, scrollPosition: .None)
        updateOrderDetail()
    }
    
    func orderListDidPlus(product: TMProduct) {
        var quantity = product.quantity.integerValue + 1
        
        product.quantity = NSNumber(integer: quantity)
        tableView.reloadRowsAtIndexPaths([editIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
        tableView.selectRowAtIndexPath(editIndexPath, animated: false, scrollPosition: .None)
        
        updateOrderDetail()
    }
}

// MARK: - 点击菜品

extension TMTakeOrderViewController: TMProductListViewControllerDelegate {
    
    func productListViewController(viewController: TMProductListViewController, didSelectedProduct: TMProduct) {
        
        var orderProduct: TMProduct?
        
        var index = 0
        for ; index < orderProductList.count; ++index {
            var record = orderProductList[index]
            if record.product_id == didSelectedProduct.product_id {
                orderProduct = record
                break
            }
        }
        
        if orderProduct != nil {
            var quantity: Int = orderProduct!.quantity.integerValue
            quantity += 1
            orderProduct!.quantity = NSNumber(integer: quantity)
//            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        } else {
            orderProduct = didSelectedProduct
            orderProduct?.quantity = 1
            orderProductList.append(orderProduct!)
//            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
        }
        
        updateOrderDetail()
        
        tableView.reloadData()
        if editIndexPath != nil {
            tableView.selectRowAtIndexPath(editIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
        }
        
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }
}
