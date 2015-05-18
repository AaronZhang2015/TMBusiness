//
//  TMLoginView.swift
//  TMBusiness
//
//  Created by ZhangMing on 15/4/2.
//  Copyright (c) 2015年 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

class TMLoginView: UIView {
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // bg image view
        backgroundColor = UIColor(hex: 0xF4F4F4)
        
        var topImageView = UIImageView(image: UIImage(named: "loginbg_top"))
        topImageView.top = 0
        topImageView.left = 20
        addSubview(topImageView)
        
        var contentView = UIView(frame: CGRectMake(20, 9, 399, 321))
        contentView.backgroundColor = UIColor.clearColor()
        addSubview(contentView)
        
        var bgView = UIImageView(image: UIImage(named: "loginbg_content"))
        contentView.addSubview(bgView)
        
        // input view
        
        // username
        var usernameBackgroundView = UIImageView(image: UIImage(named: "inputbox"))
        usernameBackgroundView.left = 45
        usernameBackgroundView.top = 66
        contentView.addSubview(usernameBackgroundView)
        
        var usernameIconView = UIImageView(image: UIImage(named: "user"))
        usernameIconView.left = 57
        usernameIconView.top = 77
        contentView.addSubview(usernameIconView)
        
        usernameTextField = UITextField(frame: CGRectMake(86, 72, 257, 30))
        usernameTextField.borderStyle = .None
        usernameTextField.placeholder = "账号"
        usernameTextField.delegate = self
        usernameTextField.returnKeyType = .Next
        contentView.addSubview(usernameTextField)
        
        // password
        var passwordBackgroundView = UIImageView(image: UIImage(named: "inputbox"))
        passwordBackgroundView.left = 45
        passwordBackgroundView.top = 129
        contentView.addSubview(passwordBackgroundView)
        
        var passwordIconView = UIImageView(image: UIImage(named: "keyword"))
        passwordIconView.left = 57
        passwordIconView.top = 140
        contentView.addSubview(passwordIconView)
        
        passwordTextField = UITextField(frame: CGRectMake(86, 135, 257, 30))
        passwordTextField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        passwordTextField.borderStyle = .None
        passwordTextField.placeholder = "密码"
        passwordTextField.secureTextEntry = true
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .Go
        contentView.addSubview(passwordTextField)
        
        // login button
        loginButton = UIButton.buttonWithType(.Custom) as! UIButton
        loginButton.setTitle("登录", forState: .Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(18.0)
        loginButton.setBackgroundImage(UIImage(named: "loginbutton"), forState: .Normal)
//        loginButton.setBackgroundImage(UIImage(named: ""), forState: .Highlighted)
        loginButton.frame = CGRectMake(45, 202, 308, 50)
        contentView.addSubview(loginButton)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension TMLoginView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginButton.sendActionsForControlEvents(.TouchUpInside)
        }
        
        return true
    }
}
