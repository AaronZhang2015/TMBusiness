//
//  BoxPaySettingViewController.swift
//  TMBusiness
//
//  Created by ZhangMing on 5/13/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

class BoxPaySettingViewController: BaseViewController {
    
    var textField: UITextField = {
        var textField = UITextField()
        textField.keyboardType = UIKeyboardType.NumberPad
        textField.returnKeyType = .Go
        textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField.placeholder = "请输入盒子SN号码"
        textField.font = UIFont.systemFontOfSize(18.0)
        return textField
        }()
    
    var commitButton: UIButton = {
        var commitButton = UIButton.buttonWithType(.Custom) as! UIButton
        commitButton.setBackgroundImage(UIImage(named: "payment_commit_button"), forState: .Normal)
        commitButton.setBackgroundImage(UIImage(named: "payment_commit_button_on"), forState: .Highlighted)
        commitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        commitButton.setTitle("绑定盒子", forState: .Normal)
        return commitButton
    }()
    
    lazy var userDataManager: TMUserDataManager = {
        return TMUserDataManager()
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "盒子支付设置"
        
        view.backgroundColor = UIColor.whiteColor()
        // 手机号码输入框背景图片
        var phoneBackgroundImageView = UIImageView(image: UIImage(named: "cash_input"))
        view.addSubview(phoneBackgroundImageView)
        phoneBackgroundImageView.snp_makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(40)
            make.trailing.equalTo(-25)
            make.height.equalTo(45)
        }
        
        view.addSubview(textField)
        textField.snp_makeConstraints { make in
            make.leading.equalTo(phoneBackgroundImageView.snp_leading).offset(15.0)
            make.height.equalTo(phoneBackgroundImageView.snp_height)
            make.top.equalTo(phoneBackgroundImageView.snp_top)
            make.trailing.equalTo(phoneBackgroundImageView.snp_trailing).offset(-15)
        }
        
        
        view.addSubview(commitButton)
        commitButton.addTarget(self, action: "handleBingBoxPayAction", forControlEvents: .TouchUpInside)
        commitButton.snp_makeConstraints { make in
            make.size.equalTo(CGSizeMake(143, 60))
            make.top.equalTo(phoneBackgroundImageView.snp_bottom).offset(20)
            make.centerX.equalTo(view.snp_centerX)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let boxPay = NSKeyedUnarchiver.unarchiveObjectWithFile(boxPath) as? TMBoxPay {
            textField.text = boxPay.sn
            commitButton.setTitle("重新绑定", forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func handleBingBoxPayAction() {
        if count(textField.text) == 0 {
            showMessage("请输入SN号码", timeout: 0.8)
            return
        }
        
        var sn = textField.text
        startActivity()
        userDataManager.fetchBoxPayEntityInfo(sn, completion: { [weak self] (boxPay, error) -> Void in
            if let strongSelf = self {
                strongSelf.stopActivity()
                
                if let e = error {
                    strongSelf.showMessage("绑定失败", timeout: 1.0)
                } else {
                    // 绑定成功，持久化
                    if let boxPay = boxPay {
                        if NSKeyedArchiver.archiveRootObject(boxPay, toFile: boxPath) {
                            strongSelf.showMessage("绑定成功", timeout: 1.0)
                        }
                    }
                }
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
