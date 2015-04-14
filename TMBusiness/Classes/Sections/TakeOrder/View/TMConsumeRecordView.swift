//
//  TMConsumeRecordView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/13/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

let TMConsumeRecordCellIdentifier = "TMConsumeRecordCell"

class TMConsumeRecordView: UIView {
    
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
        titleLabel.text = "消费记录"
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
        
        var contentView = UIView()
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(hex: 0xD4D4D4).CGColor
        addSubview(contentView)
        contentView.snp_makeConstraints { make in
            make.top.equalTo(56)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(-22)
        }
        
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        addSubview(tableView)
        tableView.separatorStyle = .None
        tableView.rowHeight = 42
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(TMConsumeRecordCell.self, forCellReuseIdentifier: TMConsumeRecordCellIdentifier)
        tableView.snp_makeConstraints { make in
            make.top.equalTo(56)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(-22)
        }
        tableView.tableFooterView = UIView()
    }
}

extension TMConsumeRecordView: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = TMConsumeRecordHeaderView()
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
}

extension TMConsumeRecordView: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TMConsumeRecordCellIdentifier, forIndexPath: indexPath) as! TMConsumeRecordCell
        
        return cell
    }
}


class TMConsumeRecordCell: UITableViewCell {
    
    var productNameLabel: UILabel!
    var quantityLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        productNameLabel = UILabel()
        productNameLabel.text = "久留米寿司"
        productNameLabel.font = UIFont.systemFontOfSize(18)
        productNameLabel.textColor = UIColor(hex: 0x222222)
        addSubview(productNameLabel)
        productNameLabel.snp_makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(17)
            make.bottom.equalTo(-8)
            make.width.equalTo(280)
        }
        
        quantityLabel = UILabel()
        quantityLabel.text = "x1"
        quantityLabel.font = UIFont.systemFontOfSize(18)
        quantityLabel.textColor = UIColor(hex: 0x222222)
        addSubview(quantityLabel)
        quantityLabel.snp_makeConstraints { make in
            make.leading.equalTo(350)
            make.top.equalTo(17)
            make.bottom.equalTo(-8)
            make.trailing.equalTo(-20)
        }
    }
}

class TMConsumeRecordHeaderView: UIView {
    
    var dateLabel: UILabel!
    var amountLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var bgImageView = UIImageView()
        bgImageView.backgroundColor = UIColor(hex: 0xF3F8F9)
        addSubview(bgImageView)
        bgImageView.snp_makeConstraints { make in
            make.top.equalTo(5)
            make.leading.equalTo(7)
            make.trailing.equalTo(-7)
            make.bottom.equalTo(0)
        }
        
        dateLabel = UILabel()
        dateLabel.textColor = UIColor(hex: 0x222222)
        dateLabel.font = UIFont.systemFontOfSize(20)
        dateLabel.text = "2012-12-16"
        addSubview(dateLabel)
        dateLabel.snp_makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(5)
            make.trailing.equalTo(-5)
            make.bottom.equalTo(0)
        }
        
        amountLabel = UILabel()
        amountLabel.textColor = UIColor(hex: 0x222222)
        amountLabel.font = UIFont.systemFontOfSize(20)
        amountLabel.text = "500元"
        amountLabel.textAlignment = .Right
        addSubview(amountLabel)
        amountLabel.snp_makeConstraints { make in
            make.top.equalTo(5)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(0)
            make.width.equalTo(100)
        }
    }
}
