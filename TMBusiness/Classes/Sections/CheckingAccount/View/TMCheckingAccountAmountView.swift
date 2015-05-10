//
//  TMCheckingAccountAmountView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/27/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

let TMCheckingAccountAmountCellIdentifier = "TMCheckingAccountAmountCell"

class TMCheckingAccountAmountView: UIView {
    
    var checkingAccount: TMCheckingAccount = TMCheckingAccount()
    
    lazy var bgView: UIImageView = {
        return UIImageView(image: UIImage(named: "checking_accounts_left_bg"))
        }()
    
    lazy var employeeNoTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "员工编号"
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(20.0)
        return label
        }()
    
    lazy var employeeNoLabel: UILabel = {
        var label = UILabel()
        label.text = "#007"
        label.textColor = UIColor(hex: 0x1F91C0)
        label.font = UIFont.systemFontOfSize(20.0)
        return label
        }()
    
    lazy var amountTableView: UITableView = {
//        var tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        var tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.registerClass(TMCheckingAccountAmountCell.self, forCellReuseIdentifier: TMCheckingAccountAmountCellIdentifier)
        return tableView
        }()
    
    lazy var tableBgView: UIView = {
        var bgView = UIView()
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor(hex: 0xD4D4D4).CGColor
        return bgView
        }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
    
        addSubview(bgView)
        bgView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(11)
            make.top.equalTo(17)
            make.width.equalTo(325)
            make.height.equalTo(snp_height).offset(-34)
        }
        
        addSubview(employeeNoTitleLabel)
        employeeNoTitleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(bgView.snp_leading).offset(22)
            make.width.equalTo(82.0)
            make.top.equalTo(bgView.snp_top).offset(15)
            make.height.equalTo(19)
        }
        
        addSubview(employeeNoLabel)
        employeeNoLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(employeeNoTitleLabel.snp_trailing).offset(15)
            make.width.equalTo(100)
            make.top.equalTo(bgView.snp_top).offset(15)
            make.height.equalTo(19)
        }
        
        addSubview(tableBgView)
        tableBgView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(bgView).offset(-40)
            make.top.equalTo(bgView.snp_top).offset(50)
            make.leading.equalTo(bgView.snp_leading).offset(7)
            make.trailing.equalTo(bgView.snp_trailing).offset(-7)
        }
        
        addSubview(amountTableView)
        amountTableView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(tableBgView.snp_leading).offset(1)
            make.trailing.equalTo(tableBgView.snp_trailing).offset(-1)
            make.top.equalTo(tableBgView.snp_top).offset(1)
            make.bottom.equalTo(tableBgView.snp_bottom).offset(-1)
        }
    }
    
    func configureData(checkingAccount: TMCheckingAccount) {
        self.checkingAccount = checkingAccount
        amountTableView.reloadData()
        hidden = false
    }
   
}

extension TMCheckingAccountAmountView: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return 4
        case 2: return 11
        case 3: return 3
        case 4: return 3
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TMCheckingAccountAmountCellIdentifier, forIndexPath: indexPath) as! TMCheckingAccountAmountCell
        cell.nameLabel.font = UIFont.systemFontOfSize(16)
        cell.amountLabel.font = UIFont.systemFontOfSize(16)
        cell.backgroundColor = UIColor.whiteColor()
        cell.selectionStyle = .None
        var nameText = ""
        var amountText = ""
        let format = ".2"
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.nameLabel.font = UIFont.boldSystemFontOfSize(18.0)
                cell.amountLabel.font = UIFont.boldSystemFontOfSize(18.0)
                cell.backgroundColor = UIColor(hex: 0xf0faff)
                nameText = "应收"
//                amountText = "¥\abs(checkingAccount.amount.doubleValue).format(format))"
                amountText = "¥\(checkingAccount.amount.doubleValue.format(format))"
            } else if indexPath.row == 1 {
                nameText = "    折扣"
//                amountText = "¥\(abs(checkingAccount.discount_amount.doubleValue).format(format))"
                amountText = "¥\(checkingAccount.discount_amount.doubleValue.format(format))"
            } else if indexPath.row == 2 {
                nameText = "    优惠券"
//                amountText = "¥\(abs(checkingAccount.coupon_amount.doubleValue).format(format))"
                amountText = "¥\(checkingAccount.coupon_amount.doubleValue.format(format))"
            }
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.nameLabel.font = UIFont.boldSystemFontOfSize(17.0)
                cell.amountLabel.font = UIFont.boldSystemFontOfSize(17.0)
                cell.backgroundColor = UIColor(hex: 0xf0faff)
                nameText = "实收"
                amountText = "¥\(abs(checkingAccount.actual_amount.doubleValue).format(format))"
            } else if indexPath.row == 1 {
                nameText = "    会员卡消费"
                amountText = "¥\(abs(checkingAccount.balance_amount.doubleValue).format(format))"
            } else if indexPath.row == 2 {
                nameText = "    刷卡消费"
                amountText = "¥\(abs(checkingAccount.box_amount.doubleValue).format(format))"
            } else if indexPath.row == 3 {
                nameText = "    现金消费"
                amountText = "¥\(abs(checkingAccount.cash_amount.doubleValue).format(format))"
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                cell.nameLabel.font = UIFont.boldSystemFontOfSize(17.0)
                cell.amountLabel.font = UIFont.boldSystemFontOfSize(17.0)
                cell.backgroundColor = UIColor(hex: 0xf0faff)
                nameText = "会员卡实际充值总额"
                amountText = "¥\(abs(checkingAccount.recharge_amount.actual_amount.doubleValue).format(format))"
            } else if indexPath.row == 1 {
                nameText = "    刷卡实际充值"
                amountText = "¥\(abs(checkingAccount.recharge_box.actual_amount.doubleValue).format(format))"
            } else if indexPath.row == 2 {
                nameText = "    刷卡充值后"
                amountText = "¥\(abs(checkingAccount.recharge_box.total_amount.doubleValue).format(format))"
            } else if indexPath.row == 3 {
                nameText = "    现金实际充值"
                amountText = "¥\(abs(checkingAccount.recharge_cash.actual_amount.doubleValue).format(format))"
            } else if indexPath.row == 4 {
                nameText = "    现金充值后"
                amountText = "¥\(abs(checkingAccount.recharge_cash.total_amount.doubleValue).format(format))"
            } else if indexPath.row == 5 {
                nameText = "    支付宝实际充值"
                amountText = "¥\(abs(checkingAccount.recharge_alipay.actual_amount.doubleValue).format(format))"
            } else if indexPath.row == 6 {
                nameText = "    支付宝充值后"
                amountText = "¥\(abs(checkingAccount.recharge_alipay.total_amount.doubleValue).format(format))"
            } else if indexPath.row == 7 {
                nameText = "    银联卡实际充值"
                amountText = "¥\(abs(checkingAccount.recharge_cyber_bank.actual_amount.doubleValue).format(format))"
            } else if indexPath.row == 8 {
                nameText = "    银联卡充值后"
                amountText = "¥\(abs(checkingAccount.recharge_cyber_bank.total_amount.doubleValue).format(format))"
            } else if indexPath.row == 9 {
                nameText = "    其他实际充值"
                amountText = "¥\(abs(checkingAccount.recharge_other.actual_amount.doubleValue).format(format))"
            } else if indexPath.row == 10 {
                nameText = "    其他充值后"
                amountText = "¥\(abs(checkingAccount.recharge_other.total_amount.doubleValue).format(format))"
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                cell.nameLabel.font = UIFont.boldSystemFontOfSize(17.0)
                cell.amountLabel.font = UIFont.boldSystemFontOfSize(17.0)
                cell.backgroundColor = UIColor(hex: 0xf0faff)
                nameText = "寻觅充值补贴"
                amountText = "¥\(abs(checkingAccount.subsidy.total.doubleValue).format(format))"
            } else if indexPath.row == 1 {
                nameText = "    未结算"
                amountText = "¥\(abs(checkingAccount.subsidy.unclear.doubleValue).format(format))"
            } else if indexPath.row == 2 {
                nameText = "    已结算"
                amountText = "¥\(abs(checkingAccount.subsidy.total.doubleValue - checkingAccount.subsidy.unclear.doubleValue).format(format))"
            }
        } else if indexPath.section == 4 {
            if indexPath.row == 0 {
                cell.nameLabel.font = UIFont.boldSystemFontOfSize(17.0)
                cell.amountLabel.font = UIFont.boldSystemFontOfSize(17.0)
                cell.backgroundColor = UIColor(hex: 0xf0faff)
                nameText = "对账"
                amountText = "¥\(abs(checkingAccount.recharge_amount.actual_amount.doubleValue + checkingAccount.cash_amount.doubleValue + checkingAccount.box_amount.doubleValue + checkingAccount.recharge_box.actual_amount.doubleValue).format(format))"
            } else if indexPath.row == 1 {
                nameText = "    现金收入合计"
                amountText = "¥\(abs(checkingAccount.recharge_amount.actual_amount.doubleValue + checkingAccount.cash_amount.doubleValue).format(format))"
            } else if indexPath.row == 2 {
                nameText = "    刷卡收入总额"
                amountText = "¥\(abs(checkingAccount.box_amount.doubleValue + checkingAccount.recharge_box.actual_amount.doubleValue).format(format))"
            }
        }
        
        
        cell.nameLabel.text = nameText
        cell.amountLabel.text = amountText
        
        return cell
    }
}

extension TMCheckingAccountAmountView: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = TMCheckingAccountAmountHeaderView()
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

class TMCheckingAccountAmountHeaderView: UIView {
    
    lazy var productNameTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "品名"
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(20.0)
        return label
        }()
    
    lazy var amountTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "金额"
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(20.0)
        return label
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        addSubview(productNameTitleLabel)
        productNameTitleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(snp_leading).offset(15)
            make.top.equalTo(snp_top).offset(11)
            make.width.equalTo(80)
            make.height.equalTo(18)
        }
        
        addSubview(amountTitleLabel)
        amountTitleLabel.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(snp_trailing).offset(-32)
            make.top.equalTo(snp_top).offset(11)
            make.width.equalTo(40)
            make.height.equalTo(18)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class TMCheckingAccountAmountCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.text = "员工编号"
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(18.0)
        return label
        }()
    
    lazy var amountLabel: UILabel = {
        var label = UILabel()
        label.text = "¥0.00"
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(18.0)
        return label
        }()
    
    lazy var dashView: UIImageView = {
        return UIImageView(image: UIImage(named: "checking_account_dash_line"))
        }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(14)
            make.centerY.equalTo(snp_centerY)
            make.width.lessThanOrEqualTo(170)
            make.height.equalTo(18)
        }
        
        addSubview(amountLabel)
        amountLabel.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(snp_trailing).offset(-20)
            make.centerY.equalTo(snp_centerY)
            make.width.lessThanOrEqualTo(100)
            make.height.equalTo(18)
        }
        
        addSubview(dashView)
        dashView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(1)
            make.bottom.equalTo(snp_bottom).offset(-1)
        }
    }

}
