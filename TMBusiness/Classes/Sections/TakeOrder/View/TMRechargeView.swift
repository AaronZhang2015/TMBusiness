//
//  TMRechargeView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/13/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

/**
*  充值页面
*/

let TMRechargeTypeCellIdentifier = "TMRechargeTypeCell"

class TMRechargeView: UIView {
    
    var phoneLabel: UILabel!
    var nicknameLabel: UILabel!
    
    var tableView: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var bgImageView = UIImageView(image: UIImage(named: "popup_bg_view"))
        addSubview(bgImageView)
        bgImageView.snp_makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        var titleLabel = UILabel()
        titleLabel.text = "充值"
        titleLabel.font = UIFont.systemFontOfSize(24.0)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(2)
            make.height.equalTo(45)
        }
        
        // 手机
        var phoneBackgroundImageView = UIImageView(image: UIImage(named: "cash_input"))
        addSubview(phoneBackgroundImageView)
        phoneBackgroundImageView.snp_makeConstraints { make in
            make.top.equalTo(62)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(45)
        }
        
        var phoneTitleLabel = UILabel()
        phoneTitleLabel.text = "手机"
        phoneTitleLabel.textColor = UIColor(hex: 0x222222)
        addSubview(phoneTitleLabel)
        phoneTitleLabel.snp_makeConstraints { make in
            make.leading.equalTo(phoneBackgroundImageView.snp_leading).offset(21)
            make.centerY.equalTo(phoneBackgroundImageView.snp_centerY)
            make.width.equalTo(45)
            make.height.equalTo(20)
        }
        
        
        // 昵称
        var nicknameBackgroundImageView = UIImageView(image: UIImage(named: "cash_input"))
        addSubview(nicknameBackgroundImageView)
        nicknameBackgroundImageView.snp_makeConstraints { make in
            make.top.equalTo(phoneBackgroundImageView.snp_bottom).offset(6)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(45)
        }
        
        var nicknameTitleLabel = UILabel()
        nicknameTitleLabel.text = "昵称"
        nicknameTitleLabel.textColor = UIColor(hex: 0x222222)
        addSubview(nicknameTitleLabel)
        nicknameTitleLabel.snp_makeConstraints { make in
            make.leading.equalTo(nicknameBackgroundImageView.snp_leading).offset(21)
            make.centerY.equalTo(nicknameBackgroundImageView.snp_centerY)
            make.width.equalTo(45)
            make.height.equalTo(20)
        }
        
        var rechargeBgImageView = UIImageView(image: UIImage(named: "cash_input"))
        addSubview(rechargeBgImageView)
        rechargeBgImageView.snp_makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(nicknameBackgroundImageView.snp_bottom).offset(14)
            make.height.equalTo(196)
        }
        
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.rowHeight = 63.0
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.leading.equalTo(rechargeBgImageView.snp_leading)
            make.top.equalTo(rechargeBgImageView.snp_top)
            make.bottom.equalTo(rechargeBgImageView.snp_bottom)
            make.trailing.equalTo(rechargeBgImageView.snp_trailing)
        }
        
        tableView.registerClass(TMRechargeTypeCell.self, forCellReuseIdentifier: TMRechargeTypeCellIdentifier)
        
        var cancelButton = UIButton.buttonWithType(.Custom) as! UIButton
        cancelButton.setBackgroundImage(UIImage(named: "recharge_cancel"), forState: .Normal)
        cancelButton.setBackgroundImage(UIImage(named: "recharge_cancel_on"), forState: .Highlighted)
        cancelButton.setTitleColor(UIColor(hex: 0x1E8EBC), forState: .Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        cancelButton.setTitle("取消", forState: .Normal)
        cancelButton.titleLabel?.font = UIFont.systemFontOfSize(22.0)
        addSubview(cancelButton)
        cancelButton.snp_makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalTo(rechargeBgImageView.snp_bottom).offset(21)
            make.size.equalTo(CGSizeMake(110, 50))
        }
        
        var cashButton = UIButton.buttonWithType(.Custom) as! UIButton
        cashButton.setBackgroundImage(UIImage(named: "recharge_commit"), forState: .Normal)
        cashButton.setBackgroundImage(UIImage(named: "recharge_commit_on"), forState: .Highlighted)
        cashButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cashButton.setTitle("现金", forState: .Normal)
        cashButton.titleLabel?.font = UIFont.systemFontOfSize(22.0)
        addSubview(cashButton)
        cashButton.snp_makeConstraints { make in
            make.leading.equalTo(cancelButton.snp_trailing).offset(7)
            make.top.equalTo(rechargeBgImageView.snp_bottom).offset(21)
            make.size.equalTo(CGSizeMake(110, 50))
        }
        
        var cardButton = UIButton.buttonWithType(.Custom) as! UIButton
        cardButton.setBackgroundImage(UIImage(named: "recharge_commit"), forState: .Normal)
        cardButton.setBackgroundImage(UIImage(named: "recharge_commit_on"), forState: .Highlighted)
        cardButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cardButton.setTitle("刷卡", forState: .Normal)
        cardButton.titleLabel?.font = UIFont.systemFontOfSize(22.0)
        addSubview(cardButton)
        cardButton.snp_makeConstraints { make in
            make.leading.equalTo(cashButton.snp_trailing).offset(7)
            make.top.equalTo(rechargeBgImageView.snp_bottom).offset(21)
            make.size.equalTo(CGSizeMake(110, 50))
        }
    }
    
}

extension TMRechargeView: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TMRechargeTypeCell
        cell.rechargeTypeButton.selected = true
    }
}

extension TMRechargeView: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TMRechargeTypeCellIdentifier, forIndexPath: indexPath) as! TMRechargeTypeCell
        return cell
    }
}


class TMRechargeTypeCell: UITableViewCell {
    
    var rechargeTypeButton: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        rechargeTypeButton = UIButton.buttonWithType(.Custom) as! UIButton
        rechargeTypeButton.setBackgroundImage(UIImage(named: "recharge_cell"), forState: .Normal)
        rechargeTypeButton.setBackgroundImage(UIImage(named: "recharge_cell_on"), forState: .Highlighted)
        rechargeTypeButton.setBackgroundImage(UIImage(named: "recharge_cell_on"), forState: .Selected)
        rechargeTypeButton.setBackgroundImage(UIImage(named: "recharge_cell"), forState: .Selected | .Highlighted)
        rechargeTypeButton.userInteractionEnabled = false
        addSubview(rechargeTypeButton)
        
        rechargeTypeButton.snp_makeConstraints { make in
            make.leading.equalTo(17.0)
            make.trailing.equalTo(-17.0)
            make.top.equalTo(12.0)
            make.height.equalTo(50.0)
        }
    }
}
