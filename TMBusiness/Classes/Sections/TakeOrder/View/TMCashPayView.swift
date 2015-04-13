//
//  TMCashPayView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/8/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

/**
*  现金支付页面
*/
class TMCashPayView: UIView {
    var backButton: UIButton!
    var consumeLabel: UILabel!
    var actualLabel: UILabel!
    var chargeLabel: UILabel!
    var leftPanelImageView: UIImageView!
    var panelImageView: UIImageView!
    
    var isDraging: Bool = false
    var calculateClosure: (() -> ())!
    var backClosure: (() -> ())!
    
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
        backButton = UIButton.buttonWithType(.Custom) as UIButton
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
        
        var consumeTitleLabel = UILabel()
        consumeTitleLabel.text = "消费金额"
        consumeTitleLabel.font = UIFont.systemFontOfSize(20.0)
        consumeTitleLabel.textColor = UIColor(hex: 0x222222)
        consumeTitleLabel.textAlignment = .Right
        addSubview(consumeTitleLabel)
        consumeTitleLabel.snp_makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalTo(24)
            make.left.equalTo(27)
            make.top.equalTo(self.backButton.snp_bottom).with.offset(22)
        }
        
        consumeLabel = UILabel()
        consumeLabel.text = "10000"
        consumeLabel.font = UIFont.systemFontOfSize(20.0)
        consumeLabel.textColor = UIColor(hex: 0x222222)
        consumeLabel.textAlignment = .Left
        addSubview(consumeLabel)
        consumeLabel.snp_makeConstraints { make in
            make.leading.equalTo(consumeTitleLabel.snp_trailing).with.offset(37)
            make.top.equalTo(consumeTitleLabel.snp_top)
            make.width.greaterThanOrEqualTo(20)
            make.height.equalTo(consumeTitleLabel.snp_height)
        }
        
        var yuan1Label = UILabel()
        yuan1Label.text = "元"
        yuan1Label.font = UIFont.systemFontOfSize(20.0)
        yuan1Label.textColor = UIColor(hex: 0x222222)
        addSubview(yuan1Label)
        yuan1Label.snp_makeConstraints { make in
            make.leading.equalTo(self.consumeLabel.snp_trailing).with.offset(10)
            make.width.equalTo(20)
            make.height.equalTo(consumeTitleLabel.snp_height)
            make.top.equalTo(consumeTitleLabel.snp_top)
        }
        
        var actualTitleLabel = UILabel()
        actualTitleLabel.text = "顾客支付"
        actualTitleLabel.font = UIFont.systemFontOfSize(20.0)
        actualTitleLabel.textColor = UIColor(hex: 0x222222)
        actualTitleLabel.textAlignment = .Right
        addSubview(actualTitleLabel)
        actualTitleLabel.snp_makeConstraints { make in
            make.width.equalTo(consumeTitleLabel.snp_width)
            make.height.equalTo(consumeTitleLabel.snp_height)
            make.left.equalTo(consumeTitleLabel.snp_left)
            make.top.equalTo(consumeTitleLabel.snp_bottom).with.offset(34)
        }
        
        var cashInputImageView = UIImageView(image: UIImage(named: "cash_input"))
        addSubview(cashInputImageView)
        
        actualLabel = UILabel()
        actualLabel.text = "0"
        actualLabel.font = UIFont.systemFontOfSize(20.0)
        actualLabel.textColor = UIColor(hex: 0x25B1E9)
        actualLabel.textAlignment = .Left
        addSubview(actualLabel)
        actualLabel.snp_makeConstraints { make in
            make.leading.equalTo(actualTitleLabel.snp_trailing).with.offset(37)
            make.top.equalTo(actualTitleLabel.snp_top)
            make.width.greaterThanOrEqualTo(20)
            make.height.equalTo(actualTitleLabel.snp_height)
        }
        
        // 计算背景图片
        cashInputImageView.snp_makeConstraints { make in
            make.leading.equalTo(actualTitleLabel.snp_trailing).with.offset(20)
            make.width.equalTo(self.actualLabel.snp_width).offset(34)
            make.height.equalTo(50)
            make.top.equalTo(consumeTitleLabel.snp_bottom).width.offset(21)
        }
        
        var yuan2Label = UILabel()
        yuan2Label.text = "元"
        yuan2Label.font = UIFont.systemFontOfSize(20.0)
        yuan2Label.textColor = UIColor(hex: 0x222222)
        addSubview(yuan2Label)
        yuan2Label.snp_makeConstraints { make in
            make.leading.equalTo(cashInputImageView.snp_trailing).with.offset(10)
            make.width.equalTo(20)
            make.height.equalTo(actualTitleLabel.snp_height)
            make.top.equalTo(actualTitleLabel.snp_top)
        }
        
        var chargeTitleLabel = UILabel(frame: CGRectMake(27, actualTitleLabel.bottom + 34, 110, 48))
        chargeTitleLabel.text = "找零"
        chargeTitleLabel.font = UIFont.systemFontOfSize(20.0)
        chargeTitleLabel.textColor = UIColor(hex: 0x222222)
        chargeTitleLabel.textAlignment = .Right
        addSubview(chargeTitleLabel)
        chargeTitleLabel.snp_makeConstraints { make in
            make.width.equalTo(actualTitleLabel.snp_width)
            make.height.equalTo(actualTitleLabel.snp_height)
            make.left.equalTo(actualTitleLabel.snp_left)
            make.top.equalTo(actualTitleLabel.snp_bottom).with.offset(32)
        }
        
        chargeLabel = UILabel()//(frame: CGRectMake(chargeTitleLabel.right + 37, actualTitleLabel.top, 200, 48))
        chargeLabel.text = "104"
        chargeLabel.font = UIFont.systemFontOfSize(20.0)
        chargeLabel.textColor = UIColor(hex: 0xFE0100)
        chargeLabel.textAlignment = .Left
        addSubview(chargeLabel)
        
        chargeLabel.snp_makeConstraints { make in
            make.leading.equalTo(chargeTitleLabel.snp_trailing).with.offset(37)
            make.top.equalTo(chargeTitleLabel.snp_top)
            make.width.greaterThanOrEqualTo(20)
            make.height.equalTo(chargeTitleLabel.snp_height)
        }
        
        var yuan3Label = UILabel()
        yuan3Label.text = "元"
        yuan3Label.font = UIFont.systemFontOfSize(20.0)
        yuan3Label.textColor = UIColor(hex: 0x222222)
        addSubview(yuan3Label)
        yuan3Label.snp_makeConstraints { make in
            make.leading.equalTo(self.chargeLabel.snp_trailing).with.offset(10)
            make.width.equalTo(20)
            make.height.equalTo(chargeTitleLabel.snp_height)
            make.top.equalTo(chargeTitleLabel.snp_top)
        }
        
        var button1 = createNumberButton("1", tag: 1)
        addSubview(button1)
        button1.snp_makeConstraints { make in
            make.width.equalTo(115)
            make.height.equalTo(100)
            make.left.equalTo(27)
            make.top.equalTo(chargeTitleLabel.snp_bottom).with.offset(45)
        }
        
        var button2 = createNumberButton("2", tag: 2)
        addSubview(button2)
        button2.snp_makeConstraints { make in
            make.width.equalTo(button1.snp_width)
            make.height.equalTo(button1.snp_height)
            make.left.equalTo(button1.snp_trailing).with.offset(10)
            make.top.equalTo(button1.snp_top)
        }
        
        var button3 = createNumberButton("3", tag: 3)
        addSubview(button3)
        button3.snp_makeConstraints { make in
            make.width.equalTo(button1.snp_width)
            make.height.equalTo(button1.snp_height)
            make.left.equalTo(button2.snp_trailing).with.offset(10)
            make.top.equalTo(button1.snp_top)
        }
        
        
        var button4 = createNumberButton("4", tag: 4)
        addSubview(button4)
        button4.snp_makeConstraints { make in
            make.width.equalTo(button1.snp_width)
            make.height.equalTo(button1.snp_height)
            make.left.equalTo(button1.snp_left)
            make.top.equalTo(button1.snp_bottom).with.offset(10)
        }
        
        var button5 = createNumberButton("5", tag: 5)
        addSubview(button5)
        button5.snp_makeConstraints { make in
            make.width.equalTo(button1.snp_width)
            make.height.equalTo(button1.snp_height)
            make.left.equalTo(button4.snp_trailing).with.offset(10)
            make.top.equalTo(button4.snp_top)
        }
        
        var button6 = createNumberButton("6", tag: 6)
        addSubview(button6)
        button6.snp_makeConstraints { make in
            make.width.equalTo(button1.snp_width)
            make.height.equalTo(button1.snp_height)
            make.left.equalTo(button5.snp_trailing).with.offset(10)
            make.top.equalTo(button4.snp_top)
        }
        
        var button7 = createNumberButton("7", tag: 7)
        addSubview(button7)
        button7.snp_makeConstraints { make in
            make.width.equalTo(button1.snp_width)
            make.height.equalTo(button1.snp_height)
            make.left.equalTo(button1.snp_left)
            make.top.equalTo(button4.snp_bottom).with.offset(10)
        }
        
        var button8 = createNumberButton("8", tag: 8)
        addSubview(button8)
        button8.snp_makeConstraints { make in
            make.width.equalTo(button1.snp_width)
            make.height.equalTo(button1.snp_height)
            make.left.equalTo(button7.snp_trailing).with.offset(10)
            make.top.equalTo(button7.snp_top)
        }
        
        var button9 = createNumberButton("9", tag: 9)
        addSubview(button9)
        button9.snp_makeConstraints { make in
            make.width.equalTo(button1.snp_width)
            make.height.equalTo(button1.snp_height)
            make.left.equalTo(button8.snp_trailing).with.offset(10)
            make.top.equalTo(button7.snp_top)
        }
        
        // 小数点
        var buttonDot = createNumberButton(".", tag: 10)
        addSubview(buttonDot)
        buttonDot.snp_makeConstraints { make in
            make.width.equalTo(button1.snp_width)
            make.height.equalTo(button1.snp_height)
            make.left.equalTo(button1.snp_left)
            make.top.equalTo(button7.snp_bottom).with.offset(10)
        }
        
        // 数字0
        var button0 = createNumberButton("0", tag: 0)
        addSubview(button0)
        button0.snp_makeConstraints { make in
            make.width.equalTo(button1.snp_width)
            make.height.equalTo(button1.snp_height)
            make.left.equalTo(buttonDot.snp_trailing).with.offset(10)
            make.top.equalTo(buttonDot.snp_top)
        }
        
        // 删除
        var buttonDelete = createNumberButton("删除", tag: 20)
        addSubview(buttonDelete)
        buttonDelete.snp_makeConstraints { make in
            make.width.equalTo(button1.snp_width)
            make.height.equalTo(button1.snp_height)
            make.left.equalTo(button0.snp_trailing).with.offset(10)
            make.top.equalTo(buttonDot.snp_top)
        }
        
        // 结算
        var buttonCalculate = createNumberButton("结算", tag: 21, reverse: true)
        buttonCalculate.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonCalculate.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20)
        addSubview(buttonCalculate)
        buttonCalculate.snp_makeConstraints { make in
            make.width.equalTo(121)
            make.height.equalTo(212)
            make.top.equalTo(button1.snp_top)
            make.left.equalTo(button3.snp_trailing).with.offset(10)
        }
        
        var buttonCancel = createNumberButton("清空", tag: 22)
        buttonCancel.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonCancel.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20)
        addSubview(buttonCancel)
        buttonCancel.snp_makeConstraints { make in
            make.width.equalTo(buttonCalculate.snp_width)
            make.height.equalTo(buttonCalculate.snp_height)
            make.top.equalTo(buttonCalculate.snp_bottom).with.offset(10)
            make.left.equalTo(button3.snp_trailing).with.offset(10)
        }
    }
    
    /**
    创建数字按钮
    
    :param: number  数字内容
    :param: tag     索引号
    :param: reverse 图片是否倒置
    
    :returns: 按钮
    */
    func createNumberButton(number: String, tag: Int, reverse: Bool = false) -> UIButton {
        var button = UIButton.buttonWithType(.Custom) as UIButton
        
        if reverse {
            button.setBackgroundImage(UIImage(named: "cash_button"), forState: .Highlighted)
            button.setBackgroundImage(UIImage(named: "cash_button_on"), forState: .Normal)
            button.setTitleColor(UIColor(hex: 0x222222), forState: .Highlighted)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        } else {
            button.setBackgroundImage(UIImage(named: "cash_button"), forState: .Normal)
            button.setBackgroundImage(UIImage(named: "cash_button_on"), forState: .Highlighted)
            button.setTitleColor(UIColor(hex: 0x222222), forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        }
        button.setTitle(number, forState: .Normal)
        
        button.tag = tag
        button.titleLabel?.font = UIFont.systemFontOfSize(46)
        button.addTarget(self, action: "handleNumberTap:", forControlEvents: .TouchUpInside)
        return button
    }

    /**
    处理按钮点击事件
    
    :param: sender 按钮
    */
    func handleNumberTap(sender: AnyObject) {
        var tag = sender.tag
        
        if tag >= 0 && tag <= 10 {
            if let text = actualLabel.text {
                var number = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."][tag]
                actualLabel.text = text.hanldeAmountNumberFormat(number)
            }
        } else {
            // 删除
            if tag == 20 {
                if let text = actualLabel.text {
                    var length = countElements(text)
                    if length >= 1 {
                        actualLabel.text = (text as NSString).substringToIndex(length - 1)
                    }

                    if countElements(actualLabel.text!) == 0 {
                        actualLabel.text = "0"
                    }
                } else {
                    actualLabel.text = "0"
                }
            } else if tag == 21 {
                calculateClosure()
            } else if tag == 22 {
                actualLabel.text = "0"
            }
        }
        
        updateAmountDetail()
    }
    
    /**
    刷新金额详情
    */
    func updateAmountDetail() {
        if let consumeAmount = consumeLabel.text {
            if let actualAmount = actualLabel.text  {
                let consume = (consumeAmount as NSString).doubleValue
                let actual = (actualAmount as NSString).doubleValue
                let charge = actual - consume
                let format = ".2"
                
                chargeLabel.text = "\(charge.format(format))"
            }
        }
    }
    
    /**
    后退按钮事件
    */
    func handleBackAction() {
        backClosure()
    }
}

extension TMCashPayView {
    // MARK - UITouch Events
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        var touch = touches.anyObject() as UITouch
        var point = touch.locationInView(self)
        if CGRectContainsPoint(panelImageView.frame, point) {
            isDraging = true
            leftPanelImageView.highlighted = true
            panelImageView.highlighted = true
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        var touch = touches.anyObject() as UITouch
        var point = touch.locationInView(self)
        
        if isDraging {
            var distance = point.x
            
            self.frame.left += distance
        }
        
        println("touchesMoved")
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        var touch = touches.anyObject() as UITouch
        var point = touch.locationInView(self)
        isDraging = false
        leftPanelImageView.highlighted = false
        panelImageView.highlighted = false
        println("touchesEnded")
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
        
        var touch = touches.anyObject() as UITouch
        var point = touch.locationInView(self)
        
        isDraging = false
        leftPanelImageView.highlighted = false
        panelImageView.highlighted = false
        
        println("point = \(point)")
        
        println("touchesCancelled")
    }
}
