//
//  TMMemebershipCardPayView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/10/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

class TMMemebershipCardPayView: UIView {
    
    var backButton: UIButton!
    var consumeLabel: UILabel!
    var actualLabel: UILabel!
    var chargeLabel: UILabel!
    var leftPanelImageView: UIImageView!
    var panelImageView: UIImageView!
    
    // 手机号码
    var phoneNumberTextField: UITextField!
    
    // 手机号码显示
    var phoneNumberLabel: UILabel!
    
    // 昵称显示
    var nicknameLabel: UILabel!
    
    // 余额显示
    var balanceLabel: UILabel!
    
    // 折扣显示
    var discountLabel: UILabel!
    
    // 消费金额
    var consumeAmountLabel: UILabel!
    
    // 优惠金额
    var discountAmountLabel: UILabel!
    
    // 实际金额
    var actualAmountLabel: UILabel!
    
    // 备注
    var remarkTextView: AZPlaceholderTextView!
    
    // 充值按钮
    var rechargeButton: UIButton!
    
    // 消费记录
    var consumeButton: UIButton!
    
    var isDraging: Bool = false
    var backClosure: (() -> ())?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hex: 0xFCFCFC)
        
        leftPanelImageView = UIImageView(image: UIImage(named: "panel"))
        leftPanelImageView.highlightedImage = UIImage(named: "panel_on")
        addSubview(leftPanelImageView)
        leftPanelImageView.snp_makeConstraints { make in
            make.width.equalTo(3)
            make.height.equalTo(self.snp_height)
            make.left.equalTo(0)
            make.top.equalTo(0)
        }
        
        panelImageView = UIImageView(image: UIImage(named: "panel_button"))
        panelImageView.highlightedImage = UIImage(named: "panel_button_on")
        addSubview(panelImageView)
        panelImageView.snp_makeConstraints { make in
            make.width.equalTo(27)
            make.height.equalTo(32)
            make.left.equalTo(self.leftPanelImageView.snp_trailing)
            make.centerY.equalTo(self.leftPanelImageView.snp_centerY)
        }
        
        // 返回按钮
        backButton = UIButton.buttonWithType(.Custom) as! UIButton
        backButton.setTitle("返回", forState: .Normal)
        backButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        backButton.titleEdgeInsets = UIEdgeInsetsMake(0, -100, 0, 0)
        backButton.setImage(UIImage(named: "back"), forState: .Normal)
        backButton.setImage(UIImage(named: "back_on"), forState: .Highlighted)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0)
        backButton.addTarget(self, action: "handleBackAction", forControlEvents: .TouchUpInside)
        addSubview(backButton)
        backButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(12)
            make.left.equalTo(25)
            make.width.equalTo(100)
            make.height.equalTo(35)
        }
        
        
        // 手机号码输入框背景图片
        var phoneBackgroundImageView = UIImageView(image: UIImage(named: "cash_input"))
        addSubview(phoneBackgroundImageView)
        phoneBackgroundImageView.snp_makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(self.backButton.snp_bottom).offset(20)
            make.width.equalTo(410)
            make.height.equalTo(45)
        }
        
        // 手机号码
        phoneNumberTextField = UITextField()
        phoneNumberTextField.keyboardType = UIKeyboardType.PhonePad
        phoneNumberTextField.returnKeyType = .Go
        phoneNumberTextField.placeholder = "请输入手机号码"
        phoneNumberTextField.font = UIFont.systemFontOfSize(18.0)
        addSubview(phoneNumberTextField)
        phoneNumberTextField.snp_makeConstraints { make in
            make.leading.equalTo(phoneBackgroundImageView.snp_leading).offset(15.0)
            make.height.equalTo(phoneBackgroundImageView.snp_height)
            make.top.equalTo(phoneBackgroundImageView.snp_top)
            make.trailing.equalTo(phoneBackgroundImageView.snp_trailing).offset(-60)
        }
        
        // 中间分割线
        var phoneSeparatorView = UIImageView(image: UIImage(named: "phone_separator"))
        addSubview(phoneSeparatorView)
        phoneSeparatorView.snp_makeConstraints { make in
            make.trailing.equalTo(phoneBackgroundImageView.snp_trailing).offset(-53)
            make.height.equalTo(25.0)
            make.width.equalTo(1.0)
            make.centerY.equalTo(phoneBackgroundImageView.snp_centerY)
        }
        
        // 搜索按钮
        var searchButton = UIButton.buttonWithType(.Custom) as! UIButton
        searchButton.setImage(UIImage(named: "search_button"), forState: .Normal)
        searchButton.setImage(UIImage(named: "search_button_on"), forState: .Highlighted)
        addSubview(searchButton)
        searchButton.snp_makeConstraints { make in
            make.size.equalTo(CGSizeMake(22, 22))
            make.centerY.equalTo(phoneBackgroundImageView.snp_centerY)
            make.leading.equalTo(phoneSeparatorView.snp_trailing).offset(15.0)
        }
        
        // 扫一扫按钮
        var scanButton = UIButton.buttonWithType(.Custom) as! UIButton
        scanButton.setBackgroundImage(UIImage(named: "scan_button"), forState: .Normal)
        scanButton.setBackgroundImage(UIImage(named: "scan_button_on"), forState: .Highlighted)
        scanButton.setTitle("扫一扫", forState: .Normal)
        scanButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addSubview(scanButton)
        scanButton.snp_makeConstraints { make in
            make.size.equalTo(CGSizeMake(100, 45))
            make.centerY.equalTo(phoneBackgroundImageView.snp_centerY)
            make.leading.equalTo(phoneBackgroundImageView.snp_trailing).offset(10.0)
        }
        
        // 手机
        var phoneTitleLabel = UILabel()
        phoneTitleLabel.font = UIFont.systemFontOfSize(20.0)
        phoneTitleLabel.textColor = UIColor(hex: 0x222222)
        phoneTitleLabel.textAlignment = .Left
        phoneTitleLabel.text = "手机"
        addSubview(phoneTitleLabel)
        phoneTitleLabel.snp_makeConstraints { make in
            make.top.equalTo(phoneBackgroundImageView.snp_bottom).offset(24)
            make.width.equalTo(85.0)
            make.height.equalTo(20.0)
            make.leading.equalTo(41)
        }
        
        phoneNumberLabel = UILabel()
        phoneNumberLabel.font = UIFont.systemFontOfSize(20.0)
        phoneNumberLabel.textColor = UIColor(hex: 0x222222)
        phoneNumberLabel.textAlignment = .Left
        phoneNumberLabel.text = "13813813811"
        addSubview(phoneNumberLabel)
        phoneNumberLabel.snp_makeConstraints { make in
            make.top.equalTo(phoneTitleLabel.snp_top)
            make.width.equalTo(180.0)
            make.height.equalTo(20.0)
            make.leading.equalTo(phoneTitleLabel.snp_trailing).offset(10.0)
        }
        
        // 昵称
        var nicknameTitleLabel = UILabel()
        nicknameTitleLabel.font = UIFont.systemFontOfSize(20.0)
        nicknameTitleLabel.textColor = UIColor(hex: 0x222222)
        nicknameTitleLabel.textAlignment = .Left
        nicknameTitleLabel.text = "昵称"
        addSubview(nicknameTitleLabel)
        nicknameTitleLabel.snp_makeConstraints { make in
            make.top.equalTo(phoneTitleLabel.snp_top)
            make.width.equalTo(85)
            make.height.equalTo(20.0)
            make.leading.equalTo(self.phoneNumberLabel.snp_trailing).offset(0.0)
        }
        
        nicknameLabel = UILabel()
        nicknameLabel.font = UIFont.systemFontOfSize(20.0)
        nicknameLabel.textColor = UIColor(hex: 0x222222)
        nicknameLabel.textAlignment = .Left
        nicknameLabel.text = "昵称"
        addSubview(nicknameLabel)
        nicknameLabel.snp_makeConstraints { make in
            make.top.equalTo(phoneTitleLabel.snp_top)
            make.trailing.equalTo(self.snp_trailing).offset(-20)
            make.height.equalTo(20.0)
            make.leading.equalTo(nicknameTitleLabel.snp_trailing).offset(10.0)
        }
        
        // 余额
        var balanceTitleLabel = UILabel()
        balanceTitleLabel.font = UIFont.systemFontOfSize(20.0)
        balanceTitleLabel.textColor = UIColor(hex: 0x222222)
        balanceTitleLabel.textAlignment = .Left
        balanceTitleLabel.text = "余额"
        addSubview(balanceTitleLabel)
        balanceTitleLabel.snp_makeConstraints { make in
            make.top.equalTo(phoneTitleLabel.snp_bottom).offset(30)
            make.width.equalTo(85.0)
            make.height.equalTo(20.0)
            make.leading.equalTo(41)
        }
        
        balanceLabel = UILabel()
        balanceLabel.font = UIFont.systemFontOfSize(20.0)
        balanceLabel.textColor = UIColor(hex: 0x222222)
        balanceLabel.textAlignment = .Left
        balanceLabel.text = "2000.00"
        addSubview(balanceLabel)
        balanceLabel.snp_makeConstraints { make in
            make.top.equalTo(balanceTitleLabel.snp_top)
            make.width.equalTo(82)
            make.height.equalTo(20.0)
            make.leading.equalTo(balanceTitleLabel.snp_trailing).offset(10.0)
        }
        
        // 充值按钮
        rechargeButton = UIButton.buttonWithType(.Custom) as! UIButton
        rechargeButton.setBackgroundImage(UIImage(named: "recharge_button"), forState: .Normal)
        rechargeButton.setBackgroundImage(UIImage(named: "recharge_button_on"), forState: .Highlighted)
        rechargeButton.setTitle("充值", forState: .Normal)
        rechargeButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        rechargeButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(rechargeButton)
        rechargeButton.snp_makeConstraints { make in
            make.size.equalTo(CGSizeMake(80, 45))
            make.trailing.equalTo(self.snp_trailing).offset(-20.0)
            make.centerY.equalTo(self.balanceLabel.snp_centerY)
        }
        
        // 折扣
        var discountTitleLabel = UILabel()
        discountTitleLabel.font = UIFont.systemFontOfSize(20.0)
        discountTitleLabel.textColor = UIColor(hex: 0x222222)
        discountTitleLabel.textAlignment = .Left
        discountTitleLabel.text = "折扣"
        addSubview(discountTitleLabel)
        discountTitleLabel.snp_makeConstraints { make in
            make.top.equalTo(balanceTitleLabel.snp_bottom).offset(30)
            make.width.equalTo(85)
            make.height.equalTo(20.0)
            make.leading.equalTo(41)
        }
        
        discountLabel = UILabel()
        discountLabel.font = UIFont.systemFontOfSize(20.0)
        discountLabel.textColor = UIColor(hex: 0x1E8EBC)
        discountLabel.textAlignment = .Left
        discountLabel.text = "7折"
        addSubview(discountLabel)
        discountLabel.snp_makeConstraints { make in
            make.top.equalTo(discountTitleLabel.snp_top)
            make.width.equalTo(60)
            make.height.equalTo(20.0)
            make.leading.equalTo(discountTitleLabel.snp_trailing).offset(10.0)
        }
        
        // checkbox
        
        // 消费记录
        var consumeTitleLabel = UILabel()
        consumeTitleLabel.font = UIFont.systemFontOfSize(20.0)
        consumeTitleLabel.textColor = UIColor(hex: 0x222222)
        consumeTitleLabel.textAlignment = .Left
        consumeTitleLabel.text = "消费记录"
        addSubview(consumeTitleLabel)
        consumeTitleLabel.snp_makeConstraints { make in
            make.top.equalTo(balanceTitleLabel.snp_bottom).offset(30)
            make.width.equalTo(85)
            make.height.equalTo(20.0)
            make.leading.equalTo(nicknameTitleLabel.snp_leading)
        }
        
        // 消费记录查看按钮
        consumeButton = UIButton.buttonWithType(.Custom) as! UIButton
        consumeButton.setBackgroundImage(UIImage(named: "recharge_button"), forState: .Normal)
        consumeButton.setBackgroundImage(UIImage(named: "recharge_button_on"), forState: .Highlighted)
        consumeButton.setTitle("查看", forState: .Normal)
        consumeButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        consumeButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        addSubview(consumeButton)
        consumeButton.snp_makeConstraints { make in
            make.size.equalTo(CGSizeMake(80, 45))
            make.trailing.equalTo(self.snp_trailing).offset(-20.0)
            make.centerY.equalTo(consumeTitleLabel.snp_centerY)
        }
        
        
        // 消费详情
        
        var consumeDetailImageView = UIImageView(image: UIImage(named: "cash_input"))
        addSubview(consumeDetailImageView)
        consumeDetailImageView.snp_makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(discountTitleLabel.snp_bottom).offset(24)
            make.trailing.equalTo(self.snp_trailing).offset(-25)
            make.height.equalTo(101)
        }
        
        // 消费金额
        var consumeAmountTitleLabel = UILabel()
        consumeAmountTitleLabel.text = "消费详情"
        consumeAmountTitleLabel.font = UIFont.systemFontOfSize(20.0)
        consumeAmountTitleLabel.textColor = UIColor(hex: 0x222222)
        consumeAmountTitleLabel.textAlignment = .Left
        addSubview(consumeAmountTitleLabel)
        consumeAmountTitleLabel.snp_makeConstraints { make in
            make.top.equalTo(consumeDetailImageView.snp_top).offset(15)
            make.width.equalTo(85)
            make.height.equalTo(20.0)
            make.leading.equalTo(41)
        }
        
        consumeAmountLabel = UILabel()
        consumeAmountLabel.text = "¥150.00"
        consumeAmountLabel.font = UIFont.systemFontOfSize(20.0)
        consumeAmountLabel.textColor = UIColor(hex: 0x222222)
        consumeAmountLabel.textAlignment = .Right
        addSubview(consumeAmountLabel)
        consumeAmountLabel.snp_makeConstraints { make in
            make.trailing.equalTo(nicknameTitleLabel.snp_leading).offset(-35)
            make.leading.equalTo(consumeAmountTitleLabel).offset(10)
            make.height.equalTo(20.0)
            make.top.equalTo(consumeAmountTitleLabel.snp_top)
        }
        
        // 优惠
        var discountAmountTitleLabel = UILabel()
        discountAmountTitleLabel.text = "优惠"
        discountAmountTitleLabel.font = UIFont.systemFontOfSize(20.0)
        discountAmountTitleLabel.textColor = UIColor(hex: 0x222222)
        discountAmountTitleLabel.textAlignment = .Left
        addSubview(discountAmountTitleLabel)
        discountAmountTitleLabel.snp_makeConstraints { make in
            make.leading.equalTo(nicknameTitleLabel.snp_leading)
            make.height.equalTo(20.0)
            make.top.equalTo(consumeAmountTitleLabel.snp_top)
            make.width.equalTo(85)
        }
        
        discountAmountLabel = UILabel()
        discountAmountLabel.text = "-¥50.00"
        discountAmountLabel.font = UIFont.systemFontOfSize(20.0)
        discountAmountLabel.textColor = UIColor(hex: 0x1E8EBC)
        discountAmountLabel.textAlignment = .Right
        addSubview(discountAmountLabel)
        discountAmountLabel.snp_makeConstraints { make in
            make.trailing.equalTo(consumeDetailImageView.snp_trailing).offset(-35.0)
            make.height.equalTo(20.0)
            make.top.equalTo(discountAmountTitleLabel.snp_top)
            make.leading.equalTo(discountAmountTitleLabel.snp_trailing).offset(10.0)
        }
        
        // 折后金额
        var actualAmountTitleLabel = UILabel()
        actualAmountTitleLabel.text = "折后金额"
        actualAmountTitleLabel.font = UIFont.systemFontOfSize(20.0)
        actualAmountTitleLabel.textColor = UIColor(hex: 0x222222)
        actualAmountTitleLabel.textAlignment = .Left
        addSubview(actualAmountTitleLabel)
        actualAmountTitleLabel.snp_makeConstraints { make in
            make.bottom.equalTo(consumeDetailImageView.snp_bottom).offset(-15)
            make.width.equalTo(85)
            make.height.equalTo(20.0)
            make.leading.equalTo(41)
        }
        
        actualAmountLabel = UILabel()
        actualAmountLabel.text = "¥100.00"
        actualAmountLabel.font = UIFont.systemFontOfSize(20.0)
        actualAmountLabel.textColor = UIColor(hex: 0xFE0200)
        actualAmountLabel.textAlignment = .Right
        addSubview(actualAmountLabel)
        actualAmountLabel.snp_makeConstraints { make in
            make.bottom.equalTo(consumeDetailImageView.snp_bottom).offset(-15)
            make.leading.equalTo(consumeAmountTitleLabel).offset(10)
            make.height.equalTo(20.0)
            make.trailing.equalTo(nicknameTitleLabel.snp_leading).offset(-35.0)
        }
        
        // 支付方式
        var payWayTitleLabel = UILabel()
        payWayTitleLabel.text = "支付方式"
        payWayTitleLabel.font = UIFont.systemFontOfSize(20.0)
        payWayTitleLabel.textColor = UIColor(hex: 0x222222)
        payWayTitleLabel.textAlignment = .Left
        addSubview(payWayTitleLabel)
        payWayTitleLabel.snp_makeConstraints { make in
            make.top.equalTo(consumeDetailImageView.snp_bottom).offset(31)
            make.width.equalTo(85)
            make.height.equalTo(20.0)
            make.leading.equalTo(41)
        }
        
        // 余额按钮
        var balanceButton = UIButton.buttonWithType(.Custom) as! UIButton
        balanceButton.setBackgroundImage(UIImage(named: "payment_button"), forState: .Normal)
        balanceButton.setBackgroundImage(UIImage(named: "payment_button_on"), forState: .Highlighted)
        balanceButton.setBackgroundImage(UIImage(named: "payment_button_on"), forState: .Selected)
        balanceButton.setBackgroundImage(UIImage(named: "payment_button"), forState: .Selected | .Highlighted)
        balanceButton.setTitle("余额", forState: .Normal)
        balanceButton.titleLabel?.font = UIFont.systemFontOfSize(20.0)
        balanceButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        balanceButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        balanceButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        balanceButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        addSubview(balanceButton)
        balanceButton.snp_makeConstraints { make in
            make.width.equalTo(137.0)
            make.height.equalTo(50.0)
            make.leading.equalTo(payWayTitleLabel.snp_trailing).offset(40.0)
            make.top.equalTo(consumeDetailImageView.snp_bottom).offset(18.0)
        }
        
        // 盒子支付按钮
        var cashBoxButton = UIButton.buttonWithType(.Custom) as! UIButton
        cashBoxButton.setBackgroundImage(UIImage(named: "payment_button"), forState: .Normal)
        cashBoxButton.setBackgroundImage(UIImage(named: "payment_button_on"), forState: .Highlighted)
        cashBoxButton.setBackgroundImage(UIImage(named: "payment_button_on"), forState: .Selected)
        cashBoxButton.setBackgroundImage(UIImage(named: "payment_button"), forState: .Selected | .Highlighted)
        
        cashBoxButton.setTitle("盒子支付", forState: .Normal)
        cashBoxButton.titleLabel?.font = balanceButton.titleLabel?.font
        cashBoxButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0)
        cashBoxButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        cashBoxButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        cashBoxButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        
        addSubview(cashBoxButton)
        cashBoxButton.snp_makeConstraints { make in
            make.width.equalTo(166.0)
            make.height.equalTo(50.0)
            make.leading.equalTo(balanceButton.snp_trailing).offset(28.0)
            make.top.equalTo(consumeDetailImageView.snp_bottom).offset(18.0)
        }
        
        // 现金支付按钮
        var cashButton = UIButton.buttonWithType(.Custom) as! UIButton
        cashButton.setBackgroundImage(UIImage(named: "payment_button"), forState: .Normal)
        cashButton.setBackgroundImage(UIImage(named: "payment_button_on"), forState: .Highlighted)
        cashButton.setBackgroundImage(UIImage(named: "payment_button_on"), forState: .Selected)
        cashButton.setBackgroundImage(UIImage(named: "payment_button"), forState: .Selected | .Highlighted)
        cashButton.setTitle("现金", forState: .Normal)
        cashButton.titleLabel?.font = balanceButton.titleLabel?.font
        cashButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        cashButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        cashButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        cashButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        addSubview(cashButton)
        cashButton.snp_makeConstraints { make in
            make.width.equalTo(137.0)
            make.height.equalTo(50.0)
            make.leading.equalTo(payWayTitleLabel.snp_trailing).offset(40.0)
            make.top.equalTo(balanceButton.snp_bottom).offset(13.0)
        }
        
        // 其他刷卡
        var otherButton = UIButton.buttonWithType(.Custom) as! UIButton
        otherButton.setBackgroundImage(UIImage(named: "payment_button"), forState: .Normal)
        otherButton.setBackgroundImage(UIImage(named: "payment_button_on"), forState: .Highlighted)
        otherButton.setBackgroundImage(UIImage(named: "payment_button_on"), forState: .Selected)
        otherButton.setBackgroundImage(UIImage(named: "payment_button"), forState: .Selected | .Highlighted)
        otherButton.setTitle("其他刷卡", forState: .Normal)
        otherButton.titleLabel?.font = balanceButton.titleLabel?.font
        otherButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0)
        
        otherButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        otherButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        otherButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        
        addSubview(otherButton)
        otherButton.snp_makeConstraints { make in
            make.width.equalTo(166.0)
            make.height.equalTo(50.0)
            make.leading.equalTo(cashButton.snp_trailing).offset(28.0)
            make.top.equalTo(balanceButton.snp_bottom).offset(13.0)
        }
        
        // 备注
        
        var remarkTitleLabel = UILabel()
        remarkTitleLabel.text = "备注"
        remarkTitleLabel.font = UIFont.systemFontOfSize(20.0)
        remarkTitleLabel.textColor = UIColor(hex: 0x222222)
        remarkTitleLabel.textAlignment = .Left
        addSubview(remarkTitleLabel)
        remarkTitleLabel.snp_makeConstraints { make in
            make.top.equalTo(cashButton.snp_bottom).offset(16)
            make.width.equalTo(44)
            make.height.equalTo(20.0)
            make.leading.equalTo(41)
        }
        
        var remarkBackgroundImageView = UIImageView(image: UIImage(named: "cash_input"))
        addSubview(remarkBackgroundImageView)
        remarkBackgroundImageView.snp_makeConstraints { make in
            make.top.equalTo(cashButton.snp_bottom).offset(15)
            make.leading.equalTo(remarkTitleLabel.snp_trailing).offset(17.0)
            make.trailing.equalTo(self.snp_trailing).offset(-35.0)
            make.height.equalTo(72)
        }
        
        remarkTextView = AZPlaceholderTextView(frame: CGRectZero)
        remarkTextView.placeholder = "请输入备注内容"
        remarkTextView.placeholderFont = UIFont.systemFontOfSize(20.0)
        remarkTextView.font = UIFont.systemFontOfSize(20.0)
        remarkTextView.textColor = UIColor(hex: 0x222222)
        addSubview(remarkTextView)
        remarkTextView.snp_makeConstraints { make in
            make.leading.equalTo(remarkBackgroundImageView.snp_leading).offset(4)
            make.trailing.equalTo(remarkBackgroundImageView.snp_trailing).offset(-4)
            make.top.equalTo(remarkBackgroundImageView.snp_top).offset(4)
            make.bottom.equalTo(remarkBackgroundImageView.snp_bottom).offset(-4)
        }
        
        
        var cancelButton = UIButton.buttonWithType(.Custom) as! UIButton
        cancelButton.setBackgroundImage(UIImage(named: "payment_cancel_button"), forState: .Normal)
        cancelButton.setBackgroundImage(UIImage(named: "payment_cancel_button_on"), forState: .Highlighted)
        cancelButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        cancelButton.setTitle("取消", forState: .Normal)
        addSubview(cancelButton)
        cancelButton.snp_makeConstraints { make in
            make.size.equalTo(CGSizeMake(143, 60))
            make.bottom.equalTo(self.snp_bottom).offset(-22)
            make.trailing.equalTo(self.snp_centerX).offset(-27)
        }
        
        var commitButton = UIButton.buttonWithType(.Custom) as! UIButton
        commitButton.setBackgroundImage(UIImage(named: "payment_commit_button"), forState: .Normal)
        commitButton.setBackgroundImage(UIImage(named: "payment_commit_button_on"), forState: .Highlighted)
        commitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        commitButton.setTitle("结账", forState: .Normal)
        addSubview(commitButton)
        commitButton.snp_makeConstraints { make in
            make.size.equalTo(CGSizeMake(143, 60))
            make.bottom.equalTo(self.snp_bottom).offset(-22)
            make.leading.equalTo(self.snp_centerX).offset(27)
        }
    }

    
    /**
    后退按钮事件
    */
    func handleBackAction() {
        if let backClosure = backClosure {
            backClosure()
        }
    }
}

extension TMMemebershipCardPayView {
    // MARK - UITouch Events
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        var touch = touches.first as! UITouch
        var point = touch.locationInView(self)
        if CGRectContainsPoint(panelImageView.frame, point) {
            isDraging = true
            leftPanelImageView.highlighted = true
            panelImageView.highlighted = true
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        
        var touch = touches.first as! UITouch
        var point = touch.locationInView(self)
        
        if isDraging {
            var distance = point.x
            self.frame.left += distance
        }
        
        println("touchesMoved")
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        var touch = touches.first as! UITouch
        var point = touch.locationInView(self)
        isDraging = false
        leftPanelImageView.highlighted = false
        panelImageView.highlighted = false
        println("touchesEnded")
        
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
        
        var touch = touches.first as! UITouch
        var point = touch.locationInView(self)
        
        isDraging = false
        leftPanelImageView.highlighted = false
        panelImageView.highlighted = false
        
        println("point = \(point)")
        
        println("touchesCancelled")
    }
}