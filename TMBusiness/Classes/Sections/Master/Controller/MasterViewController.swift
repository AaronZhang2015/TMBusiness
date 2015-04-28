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
    
    
    var currentViewController: UIViewController!
    
    private var segmentControl: TMSegmentControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (TMShop.sharedInstance.shop_id == nil) {
            presentLoginViewController()
        } else {
            // 初始化页面为点单页面
            segmentControl.selectedIndex = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        
        view.backgroundColor = UIColor.whiteColor()
        // 设置按钮
        var settingButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        settingButton.frame = CGRectMake(0, 0, 26, 26)
        settingButton.setBackgroundImage(UIImage(named: "shezhi"), forState: .Normal)
        settingButton.setBackgroundImage(UIImage(named: "shezhi_on"), forState: .Highlighted)
        var settingBarButtonItem = UIBarButtonItem(customView: settingButton)
        
        // 退出按钮
        var logoutButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        logoutButton.frame = CGRectMake(0, 0, 26, 26)
        logoutButton.setBackgroundImage(UIImage(named: "tuichu"), forState: .Normal)
        logoutButton.setBackgroundImage(UIImage(named: "tuichu_on"), forState: .Highlighted)
        var logoutBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        navigationItem.rightBarButtonItems = [settingBarButtonItem, logoutBarButtonItem]
        
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
}


// MARK: - Button Actions
extension MasterViewController {
    
    func handleSettingAction() {
        
    }
    
    func handleLogoutAction() {
        
    }
    
    func handleMenuAction(segmentControl: TMSegmentControl) {
        
        var viewController: UIViewController?
        if segmentControl.selectedIndex == 0 {
            addChildViewController(takeOrderViewController)
            view.addSubview(takeOrderViewController.view)
            takeOrderViewController.view.frame = view.bounds
            takeOrderViewController.didMoveToParentViewController(self)
            viewController = takeOrderViewController
        } else if segmentControl.selectedIndex == 1 {
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
}

extension MasterViewController: TMLoginViewControllerDelegate {
    func loginActionDidLoginSuccessful() {
        segmentControl.selectedIndex = 0
    }
}
