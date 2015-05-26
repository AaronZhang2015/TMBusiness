//
//  MasterViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 15/4/2.
//  Copyright (c) 2015年 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

class MasterViewController: BaseViewController {
    
    lazy var takeOrderViewController: TMTakeOrderViewController = {
        return TMTakeOrderViewController()
        }()
    
    lazy var orderViewController: TMOrderViewController = {
        return TMOrderViewController()
        }()
    
    lazy var checkingAccountController: TMCheckingAccountViewController = {
        return TMCheckingAccountViewController()
        }()
    
    lazy var settingViewController: BaseNavigationController = {
        var setting = TMSettingViewController()
        setting.delegate = self
        var nav = BaseNavigationController(rootViewController: setting)
        return nav
        }()
    
    lazy var maskView: UIView = {
        var view = UIView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        return view
        }()
    
    lazy var shopDataManager: TMShopDataManager = {
        return TMShopDataManager()
        }()
    
    lazy var orderDataManager: TMOrderDataManager = {
        return TMOrderDataManager()
        }()
    
    lazy var cacheDataManager: TMCacheDataManager = {
        return TMCacheDataManager()
        }()
    
    var currentViewController: UIViewController!
    
    private var segmentControl: TMSegmentControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let shop = NSKeyedUnarchiver.unarchiveObjectWithFile(shopPath) as? TMShop {
            TMShop.sharedInstance.shop_id = shop.shop_id
            TMShop.sharedInstance.business_id = shop.business_id
            TMShop.sharedInstance.shop_name = shop.shop_name
            TMShop.sharedInstance.admin_id = shop.admin_id
            TMShop.sharedInstance.admin_name = shop.admin_name
        }
        
        if (TMShop.sharedInstance.shop_id == nil) {
            presentLoginViewController()
        } else {
            // 初始化页面为点单页面
            segmentControl.selectedIndex = 0
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "getCacheStatus", name: UIApplicationWillEnterForegroundNotification, object: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        
        view.backgroundColor = UIColor.whiteColor()
        // 设置按钮
//        var settingButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
//        settingButton.frame = CGRectMake(0, 0, 36, 26)
//        settingButton.setTitle("设置", forState: .Normal)
////        settingButton.setBackgroundImage(UIImage(named: "shezhi"), forState: .Normal)
////        settingButton.setBackgroundImage(UIImage(named: "shezhi_on"), forState: .Highlighted)
//        settingButton.addTarget(self, action: "handleSettingAction", forControlEvents: .TouchUpInside)
//        var settingBarButtonItem = UIBarButtonItem(customView: settingButton)
        
        var settingBarButtonItem = UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Plain, target: self, action: "handleSettingAction")
        
        var flexibleBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        flexibleBarButtonItem.width = 30
        
        // 退出按钮
//        var logoutButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
//        logoutButton.frame = CGRectMake(0, 0, 36, 26)
////        settingButton.setTitle("退出", forState: .Normal)
//        logoutButton.setBackgroundImage(UIImage(named: "tuichu"), forState: .Normal)
//        logoutButton.setBackgroundImage(UIImage(named: "tuichu_on"), forState: .Highlighted)
//        logoutButton.addTarget(self, action: "handleLogoutAction", forControlEvents: .TouchUpInside)
//        var logoutBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        var logoutBarButtonItem = UIBarButtonItem(title: "退出", style: UIBarButtonItemStyle.Plain, target: self, action: "handleLogoutAction")
        
        var changeUserBarButtonItem = UIBarButtonItem(title: "交接班", style: UIBarButtonItemStyle.Plain, target: self, action: "changeUserAction")
        
        navigationItem.rightBarButtonItems = [settingBarButtonItem, flexibleBarButtonItem, logoutBarButtonItem, flexibleBarButtonItem, changeUserBarButtonItem]
        
        // 左边Logo
        var logoButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        logoButton.frame = CGRectMake(0, 0, 165, 32)
        logoButton.setBackgroundImage(UIImage(named: "home_logo"), forState: .Normal)
        logoButton.setBackgroundImage(UIImage(named: "home_logo"), forState: .Highlighted)
        var logoBarButtonItem = UIBarButtonItem(customView: logoButton)
        
        navigationItem.leftBarButtonItem = logoBarButtonItem
        
        // 设置分段按钮
        segmentControl = TMSegmentControl(frame: CGRectMake(0, 0, 298, 35), items: ["点单", "订单", "对账"])
        segmentControl.addTarget(self, action: "handleMenuAction:", forControlEvents: .ValueChanged)
        navigationItem.titleView = segmentControl
    }
    
    
    func presentLoginViewController() {
        var loginViewController = TMLoginViewController()
        loginViewController.delegate = self
        navigationController?.presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    func handleCheckoutAction(order: TMOrder, user: TMUser? = nil) {
        takeOrderViewController.loadFromOrderList(order, user: user)
        segmentControl.selectedIndex = 0
    }
    
    func handleChangeOrderAction(order: TMOrder, user: TMUser? = nil) {
        takeOrderViewController.loadFromOrderList(order, user: user, isChangeOrder: true)
        segmentControl.selectedIndex = 0
    }
    
    func handleMenu(selectedIndex: Int) {
        var viewController: UIViewController?
        if selectedIndex == 0 {
            addChildViewController(takeOrderViewController)
            view.addSubview(takeOrderViewController.view)
            takeOrderViewController.view.frame = view.bounds
            takeOrderViewController.didMoveToParentViewController(self)
            viewController = takeOrderViewController
        } else if selectedIndex == 1 {
            addChildViewController(orderViewController)
            view.addSubview(orderViewController.view)
            orderViewController.view.frame = view.bounds
            orderViewController.didMoveToParentViewController(self)
            
            viewController = orderViewController
        } else {
            addChildViewController(checkingAccountController)
            view.addSubview(checkingAccountController.view)
            checkingAccountController.view.frame = view.bounds
            checkingAccountController.didMoveToParentViewController(self)
            
            viewController = checkingAccountController
        }
        
        if currentViewController != nil {
            currentViewController.willMoveToParentViewController(nil)
            currentViewController.beginAppearanceTransition(false, animated: false)
            currentViewController.removeFromParentViewController()
            currentViewController.view.removeFromSuperview()
            currentViewController.didMoveToParentViewController(nil)
            currentViewController.endAppearanceTransition()
        }
        
        currentViewController = viewController
    }
    
    
    func getCacheStatus() {
        var localCacheId = cacheDataManager.fetchLocalCacheInfo(.Category)
        cacheDataManager.fetchCacheInfo(.Category, adminId: TMShop.sharedInstance.admin_id) { [weak self] (cacheId) -> Void in
            if let strongSelf = self {
                if cacheId != localCacheId {
                    NSNotificationCenter.defaultCenter().postNotificationName(TMNeedRefreshCategoryAndProductNotification, object: nil)
                }
            }
        }
    }
}


// MARK: - Button Actions
extension MasterViewController {
    
    func handleSettingAction() {
        if maskView.superview == nil {
            navigationController?.view.addSubview(maskView)
        }
        navigationController?.view.addSubview(settingViewController.view)
        var frame = UIScreen.mainScreen().bounds
        frame.left = view.width - 400
        frame.width = 400
        settingViewController.view.frame = frame
        settingViewController.didMoveToParentViewController(self)
    }
    
    func handleLogoutAction() {
        
        
        // 注销之前先判定本地是否有挂单
        var restingOrderList = orderDataManager.fetchRestingOrderList()
        
        if restingOrderList.isEmpty {
            var alert = UIAlertView(title: "提示", message: "是否注销当前用户", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "注销")
            alert.show()
        } else {
            var alert = UIAlertView(title: "提示", message: "您还有挂单尚未处理完，是否注销当前用户", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "注销")
            alert.show()
        }

    }
    
    func changeUserAction() {
        var alert = UIAlertView(title: "提示", message: "是否进行交接班", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "交接班")
        alert.tag = 1001
        alert.show()
    }
    
    func handleMenuAction(segmentControl: TMSegmentControl) {
        handleMenu(segmentControl.selectedIndex)
    }
}

extension MasterViewController: TMSettingViewControllerDelegate{
    func dismissSettingViewController() {
        settingViewController.willMoveToParentViewController(nil)
        settingViewController.beginAppearanceTransition(false, animated: false)
        settingViewController.removeFromParentViewController()
        settingViewController.view.removeFromSuperview()
        settingViewController.didMoveToParentViewController(nil)
        settingViewController.endAppearanceTransition()
        
        if maskView.superview != nil {
            maskView.removeFromSuperview()
        }
    }
}

extension MasterViewController: TMLoginViewControllerDelegate {
    func loginActionDidLoginSuccessful() {
        segmentControl.selectedIndex = 0
        takeOrderViewController.takeOrderCompute.clearAllData()
        orderViewController = TMOrderViewController()
        checkingAccountController = TMCheckingAccountViewController()
    }
}

extension MasterViewController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            takeOrderViewController.takeOrderCompute.clearAllData()
            // 删除登录信息
            if alertView.tag != 1001 {
                NSFileManager.defaultManager().removeItemAtPath(shopPath, error: nil)
                shopDataManager.clearCategoryAndProduct()
                orderDataManager.clearRestingOrder()
            }
            
            presentLoginViewController()
        }
    }
}
