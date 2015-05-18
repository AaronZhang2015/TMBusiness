//
//  TMLoginViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 15/4/2.
//  Copyright (c) 2015年 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit


let TMNeedRefreshCategoryAndProductNotification = "TMNeedRefreshCategoryAndProductNotification"

protocol TMLoginViewControllerDelegate: class {
    func loginActionDidLoginSuccessful()
}

let shopPath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last as! String).stringByAppendingPathComponent("shop")

class TMLoginViewController: BaseViewController {
    
    private var loginView: TMLoginView!
    private var headerView: TMLoginHeaderView!
    weak var delegate: TMLoginViewControllerDelegate?
    
    private lazy var shopDataManager: TMShopDataManager = {
        return TMShopDataManager()
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0xF4F4F4)
        
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        headerView = TMLoginHeaderView(frame: CGRectMake(0, 0, 1024, 111))
        view.addSubview(headerView)
        
        loginView = TMLoginView(frame: CGRectMake(293, 250 - 100, 440, 352))
        loginView.usernameTextField.becomeFirstResponder()
        view.addSubview(loginView)
        loginView.loginButton.addTarget(self, action: "handleLoginAction", forControlEvents: .TouchUpInside)
    }
}

// MARK: - Button Actions
extension TMLoginViewController {
    
    func handleLoginAction() {
        var username = loginView.usernameTextField.text
        var password = loginView.passwordTextField.text
        // test
        
        if count(username) == 0 {
            username = "ys006"
            password = "123456"
        }
        
        loginView.passwordTextField.resignFirstResponder()
        loginView.usernameTextField.resignFirstResponder()
        
        startActivity()
        shopDataManager.login(username, password: password) { [weak self] (shop, error) -> Void in
            
            if let strongSelf = self {
                strongSelf.stopActivity()
                if let e = error {
                    
                } else {
                    if let delegate = strongSelf.delegate {
                        // 持久化
                        NSKeyedArchiver.archiveRootObject(shop!, toFile: shopPath)
                        delegate.loginActionDidLoginSuccessful()
                        NSNotificationCenter.defaultCenter().postNotificationName(TMNeedRefreshCategoryAndProductNotification, object: nil)
                    }
                    strongSelf.dismissViewControllerAnimated(true, completion: nil)
                }
            }

        }
    }
}

extension TMLoginViewController: UITextFieldDelegate {
    
}
