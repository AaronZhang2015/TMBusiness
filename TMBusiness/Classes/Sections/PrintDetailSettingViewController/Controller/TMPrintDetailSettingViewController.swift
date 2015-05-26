//
//  TMPrintDetailSettingViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 5/19/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

class TMPrintDetailSettingViewController: BaseViewController {
    
    var ipAddress = ""
    var control = UIControl()
    
    lazy var label: UILabel = {
        var label = UILabel()
        label.textAlignment = .Center
        return label
        }()
    
    lazy var textField: UITextField = {
        var textField = UITextField()
        textField.delegate = self
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.returnKeyType = UIReturnKeyType.Done
        textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        return textField
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "打印机设置"
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(control)
        control.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        control.addTarget(self, action: "handleBackgroundTap", forControlEvents: .TouchUpInside)
        
        view.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(20)
            make.height.equalTo(21)
        }
        
        view.addSubview(textField)
        textField.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(20)
            make.top.equalTo(label.snp_bottom).offset(20)
            make.trailing.equalTo(20)
            make.height.equalTo(30)
        }
        
        var IPKey = "\(TMShop.sharedInstance.shop_id)_IP"
        if let value = NSUserDefaults.standardUserDefaults().stringForKey(IPKey) {
            ipAddress = value
            textField.text = value
        }
        
        var  testButton = UIButton.buttonWithType(.Custom) as! UIButton
        testButton.setBackgroundImage(UIImage(named: "checking_account_search"), forState: .Normal)
        testButton.setBackgroundImage(UIImage(named: "checking_account_search_on"), forState: .Highlighted)
        testButton.setTitle("测试", forState: .Normal)
        testButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        testButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        testButton.addTarget(self, action: "handleTestConnection", forControlEvents: .TouchUpInside)
        view.addSubview(testButton)
        testButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(textField.snp_bottom).offset(20)
            make.size.equalTo(CGSizeMake(88, 40))
            make.centerX.equalTo(view.snp_centerX)
        }
        
        asyncSocket.setRunLoopModes([NSRunLoopCommonModes])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleBackgroundTap() {
        textField.resignFirstResponder()
    }
    
    func handleTestConnection() {
        textField.resignFirstResponder()
        
        if count(ipAddress) > 0 {
            asyncSocket.disconnect()
            if !connect(ipAddress) {
                return
            }
        } else {
            label.text = "请输入ip地址"
            showMessage("请输入ip地址")
        }
    }
    
    func connect(host: String) -> Bool {
        return asyncSocket.connectToHost(host, onPort: 9100, withTimeout: 0.5, error: nil)
    }
    
    func disconnect() {
        asyncSocket.disconnect()
    }
    
    lazy var asyncSocket: AsyncSocket = {
        var socket = AsyncSocket(delegate: self)
        return socket
        }()

}

extension TMPrintDetailSettingViewController: AsyncSocketDelegate {
    func onSocket(sock: AsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        label.text = "连接成功"
        showSuccessfulMessage("连接成功")
        sock.disconnect()
    }
    
    func onSocket(sock: AsyncSocket!, willDisconnectWithError err: NSError!) {
        label.text = "连接失败，请确认ip地址正确"
        showMessage("连接失败，请确认ip地址正确")
    }
    
    func onSocketDidDisconnect(sock: AsyncSocket!) {
        println("onSocketDidDisconnect")
        
    }
    
    func onSocket(sock: AsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        
    }
    
    func onSocket(sock: AsyncSocket!, didWriteDataWithTag tag: Int) {
        
    }
}

extension TMPrintDetailSettingViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        ipAddress = textField.text
        var IPKey = "\(TMShop.sharedInstance.shop_id)_IP"
        NSUserDefaults.standardUserDefaults().setValue(ipAddress, forKey: IPKey)
        textField.resignFirstResponder()
    }
}
