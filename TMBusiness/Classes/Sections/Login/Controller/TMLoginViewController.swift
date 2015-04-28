//
//  TMLoginViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 15/4/2.
//  Copyright (c) 2015年 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

protocol TMLoginViewControllerDelegate: class {
    func loginActionDidLoginSuccessful()
}

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
        
        loginView = TMLoginView(frame: CGRectMake(293, 250, 440, 352))
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
        
        shopDataManager.login(username, password: password) { (shop, error) -> Void in
            if let e = error {
                
            } else {
                if let delegate = self.delegate {
                    delegate.loginActionDidLoginSuccessful()
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}

extension TMLoginViewController: UITextFieldDelegate {
    
}
