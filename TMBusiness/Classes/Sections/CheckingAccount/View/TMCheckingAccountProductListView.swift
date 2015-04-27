//
//  TMCheckingAccountProductListView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/27/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

let TMCheckingAccountProductListCellIdentifier = "TMCheckingAccountProductListCell"

class TMCheckingAccountProductListView: UIView {
    
    var checkingAccount: TMCheckingAccount = TMCheckingAccount()
    
    lazy var bgView: UIImageView = {
        return UIImageView(image: UIImage(named: "checking_accounts_right_bg"))
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

    lazy var tableBgView: UIView = {
        var bgView = UIView()
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor(hex: 0xD4D4D4).CGColor
        return bgView
        }()
    
    lazy var productListTableView: UITableView = {
        var tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.registerClass(TMCheckingAccountProductListCell.self, forCellReuseIdentifier: TMCheckingAccountProductListCellIdentifier)
        return tableView
        }()
    
    lazy var separatorView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "checking_account_separator"))
        return imageView
        }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(separatorView)
        separatorView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(10)
            make.bottom.equalTo(0)
        }
        
        addSubview(bgView)
        bgView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(separatorView.snp_trailing).offset(16)
            make.top.equalTo(17)
            make.width.equalTo(627)
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
        
        addSubview(productListTableView)
        productListTableView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(tableBgView.snp_leading).offset(1)
            make.trailing.equalTo(tableBgView.snp_trailing).offset(-1)
            make.top.equalTo(tableBgView.snp_top).offset(1)
            make.bottom.equalTo(tableBgView.snp_bottom).offset(-1)
        }
    }
    
    func configureData(checkingAccount: TMCheckingAccount) {
        self.checkingAccount = checkingAccount
        if checkingAccount.products.count == 0 {
            hidden = true
        } else {
            hidden = false
        }
        
        productListTableView.reloadData()
    }
}

extension TMCheckingAccountProductListView: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkingAccount.products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TMCheckingAccountProductListCellIdentifier, forIndexPath: indexPath) as! TMCheckingAccountProductListCell
        var product = checkingAccount.products[indexPath.row]
        cell.configureData(product)
        return cell
    }
}

extension TMCheckingAccountProductListView: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        
        var productLabel = UILabel(frame: CGRectMake(134, 11, 40, 18))
        productLabel.text = "品名"
        productLabel.textColor = UIColor(hex:0x222222)
        productLabel.font = UIFont.systemFontOfSize(16)
        productLabel.textAlignment = .Center
        view.addSubview(productLabel)
        
        var quantityLabel = UILabel(frame: CGRectMake(304, 11, 40, 18))
        quantityLabel.text = "数量"
        quantityLabel.textColor = UIColor(hex:0x222222)
        quantityLabel.font = UIFont.systemFontOfSize(16)
        quantityLabel.textAlignment = .Center
        view.addSubview(quantityLabel)
        
        var priceLabel = UILabel(frame: CGRectMake(404, 11, 40, 18))
        priceLabel.text = "单价"
        priceLabel.textColor = UIColor(hex:0x222222)
        priceLabel.font = UIFont.systemFontOfSize(16)
        priceLabel.textAlignment = .Center
        view.addSubview(priceLabel)
        
        var amountLabel = UILabel(frame: CGRectMake(530, 11, 40, 18))
        amountLabel.text = "金额"
        amountLabel.textColor = UIColor(hex:0x222222)
        amountLabel.font = UIFont.systemFontOfSize(16)
        amountLabel.textAlignment = .Center
        view.addSubview(amountLabel)
        
        return view
    }
}


class TMCheckingAccountProductListCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.text = "品名"
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(16)
        return label
        }()
    
    lazy var quantityLabel: UILabel = {
        var label = UILabel()
        label.text = "数量"
        label.textAlignment = .Center
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(16)
        return label
        }()
    
    lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.text = "单价"
        label.textAlignment = .Center
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(16)
        return label
        }()
    
    lazy var amountLabel: UILabel = {
        var label = UILabel()
        label.text = "金额"
        label.textAlignment = .Right
        label.textColor = UIColor(hex: 0x222222)
        label.font = UIFont.systemFontOfSize(16)
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
            make.width.equalTo(280)
            make.height.equalTo(18)
        }
        
        addSubview(quantityLabel)
        quantityLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(nameLabel.snp_trailing)
            make.centerY.equalTo(snp_centerY)
            make.width.equalTo(60)
            make.height.equalTo(18)
        }
        
        addSubview(priceLabel)
        priceLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(quantityLabel.snp_trailing).offset(20)
            make.centerY.equalTo(snp_centerY)
            make.width.equalTo(110)
            make.height.equalTo(18)
        }
        
        addSubview(amountLabel)
        amountLabel.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(snp_trailing).offset(-30)
            make.centerY.equalTo(snp_centerY)
            make.width.equalTo(100)
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
    
    func configureData(productRecord: TMProductRecord) {
        let format = ".2"
        nameLabel.text = productRecord.product_name
        quantityLabel.text = "\(productRecord.quantity.integerValue)"
        priceLabel.text = "¥\(productRecord.price.doubleValue.format(format))"
        amountLabel.text = "¥\(productRecord.total_amount.doubleValue.format(format))"
    }
}

