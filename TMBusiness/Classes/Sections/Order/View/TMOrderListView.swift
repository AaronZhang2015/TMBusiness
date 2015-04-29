//
//  TMOrderListView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/28/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

let TMOrderDetailCellIdentifier = "TMOrderDetailCell"

class TMOrderListView: UIView {
    
    var data = [TMOrder]()
    
    lazy var orderListTableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.registerClass(TMOrderDetailCell.self, forCellReuseIdentifier: TMOrderDetailCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 250
        tableView.separatorStyle = .None
        return tableView
        }()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0xF5F5F5)
        
        
        addSubview(orderListTableView)
        orderListTableView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(5)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.trailing.equalTo(-4)
        }
    }

}

extension TMOrderListView: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TMOrderDetailCellIdentifier, forIndexPath: indexPath) as! TMOrderDetailCell
        
        return cell
    }
}

extension TMOrderListView: UITableViewDelegate {
}


class TMOrderDetailCell: UITableViewCell {
    
    lazy var boxView: UIView = {
        var view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: 0xD4D4D4).CGColor
        return view
        }()
    
    lazy var dateTitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor(hex: 0x222222)
        label.text = "时间"
        return label
        }()
    
    lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor(hex: 0x438EB8)
        label.text = "2014-05-01 16:42:21"
        return label
        }()
    
    lazy var phoneNumberTitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor(hex: 0x222222)
        label.text = "手机"
        return label
        }()
    
    lazy var phoneNumberLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor(hex: 0x222222)
        label.text = "18614244256"
        return label
        }()
    
    lazy var amountTitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor(hex: 0x222222)
        label.text = "金额"
        return label
        }()
    
    lazy var amountLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor(hex: 0xFDA109)
        label.text = "500元"
        return label
        }()
    
    lazy var dashView1: UIImageView = {
        return UIImageView(image: UIImage(named: "checking_account_dash_line"))
        }()
    
    lazy var dashView2: UIImageView = {
        return UIImageView(image: UIImage(named: "checking_account_dash_line"))
        }()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        backgroundView = UIImageView(image: UIImage(named: "order_content_bg"))
        selectedBackgroundView = UIImageView(image: UIImage(named: "order_content_bg_selected"))
        
        addSubview(boxView)
        boxView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(44, 19, -36 - 12, -19))
        }
        
        // 时间
        addSubview(dateTitleLabel)
        dateTitleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(boxView.snp_leading).offset(21)
            make.top.equalTo(boxView.snp_top).offset(14)
            make.height.equalTo(22)
            make.width.equalTo(42)
        }
        
        addSubview(dateLabel)
        dateLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(dateTitleLabel.snp_trailing).offset(26)
            make.top.equalTo(dateTitleLabel.snp_top)
            make.height.equalTo(22)
            make.trailing.equalTo(boxView.snp_trailing).offset(-20)
        }
        
        addSubview(dashView1)
        dashView1.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(boxView.snp_leading)
            make.trailing.equalTo(boxView.snp_trailing)
            make.top.equalTo(boxView.snp_top).offset(50)
            make.height.equalTo(1)
        }
        
        // 手机
        addSubview(phoneNumberTitleLabel)
        phoneNumberTitleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(boxView.snp_leading).offset(21)
            make.top.equalTo(dashView1.snp_bottom).offset(14)
            make.height.equalTo(22)
            make.width.equalTo(42)
        }
        
        addSubview(phoneNumberLabel)
        phoneNumberLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(phoneNumberTitleLabel.snp_trailing).offset(26)
            make.top.equalTo(phoneNumberTitleLabel.snp_top)
            make.height.equalTo(22)
            make.trailing.equalTo(boxView.snp_trailing).offset(-20)
        }
        
        addSubview(dashView2)
        dashView2.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(boxView.snp_leading)
            make.trailing.equalTo(boxView.snp_trailing)
            make.top.equalTo(boxView.snp_top).offset(101)
            make.height.equalTo(1)
        }
        
        // 金额
        addSubview(amountTitleLabel)
        amountTitleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(boxView.snp_leading).offset(21)
            make.top.equalTo(dashView2.snp_bottom).offset(14)
            make.height.equalTo(22)
            make.width.equalTo(42)
        }
        
        addSubview(amountLabel)
        amountLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(amountTitleLabel.snp_trailing).offset(26)
            make.top.equalTo(amountTitleLabel.snp_top)
            make.height.equalTo(22)
            make.trailing.equalTo(boxView.snp_trailing).offset(-20)
        }
        
    }
    
}
