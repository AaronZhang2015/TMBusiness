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

class TMConsumeRecordView: TMModalView {
    
    var tableView: UITableView!
    
    var data:[TMOrder] = [TMOrder]()
    var contentView: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        var bgImageView = UIImageView(image: UIImage(named: "popup_bg_view"))
        addSubview(bgImageView)
        bgImageView.snp_makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(10)
            make.trailing.equalTo(-15)
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
            make.trailing.equalTo(-15)
            make.top.equalTo(12)
            make.height.equalTo(45)
        }
        
        contentView = UIView()
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(hex: 0xD4D4D4).CGColor
        addSubview(contentView)
        contentView.snp_makeConstraints { make in
            make.top.equalTo(66)
            make.leading.equalTo(15)
            make.trailing.equalTo(-30)
            make.bottom.equalTo(-22)
        }
        
        var closeButton = UIButton.buttonWithType(.Custom) as! UIButton
        closeButton.setImage(UIImage(named: "consume_close"), forState: .Normal)
        closeButton.setImage(UIImage(named: "consume_close_on"), forState: .Highlighted)
        closeButton.addTarget(self, action: "hide", forControlEvents: .TouchUpInside)
        addSubview(closeButton)
        closeButton.snp_makeConstraints { make in
            make.top.equalTo(snp_top).offset(0)
            make.trailing.equalTo(snp_trailing).offset(-12)
            make.size.equalTo(CGSizeMake(35, 35))
        }
        
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        tableView.backgroundColor = UIColor.clearColor()
        addSubview(tableView)
        tableView.separatorStyle = .None
        tableView.rowHeight = 42
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(TMConsumeRecordCell.self, forCellReuseIdentifier: TMConsumeRecordCellIdentifier)
        tableView.snp_makeConstraints { make in
            make.top.equalTo(66)
            make.leading.equalTo(15)
            make.trailing.equalTo(-30)
            make.bottom.equalTo(-22)
        }
        tableView.tableFooterView = UIView()
        
        maskModalView.addTarget(self, action: "hide", forControlEvents: .TouchUpInside)
    }
    
    func refreshData(list: [TMOrder]) {
        data = list
        tableView.reloadData()
    }
    
    func updateData(list: [TMOrder]){
        data.extend(list)
        tableView.reloadData()
    }
}

extension TMConsumeRecordView {
    /**
    显示页面
    */
    func show() {
        var window = UIApplication.sharedApplication().keyWindow
        if maskModalView.superview == nil {
            window?.addSubview(maskModalView)
        }
        
        if superview == nil {
            window?.addSubview(self)
            center = maskModalView.center
        }
        maskModalView.alpha = 0.4
        
        UIView.animateWithDuration(0.3, animations: { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.alpha = 1.0
            }
            }) { (finished) -> Void in
                return
        }
    }
    
    /**
    隐藏页面
    
    :param: animated 是否有动画
    */
    func hide() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.alpha = 0.0
            }
            }) { [weak self] (finished) -> Void in
                if let strongSelf = self {
                    strongSelf.maskModalView.alpha = 0.0
                }
        }
    }
}


extension TMConsumeRecordView: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = TMConsumeRecordHeaderView()
        view.configureData(data[section])
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
}

extension TMConsumeRecordView: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data[section].product_records!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TMConsumeRecordCellIdentifier, forIndexPath: indexPath) as! TMConsumeRecordCell
        var order = data[indexPath.section]
        cell.configureData(order.product_records![indexPath.row])
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
        quantityLabel.textAlignment = .Right
        addSubview(quantityLabel)
        quantityLabel.snp_makeConstraints { make in
            make.leading.equalTo(340)
            make.top.equalTo(17)
            make.bottom.equalTo(-8)
            make.trailing.equalTo(-20)
        }
    }
    
    func configureData(productRecord: TMProductRecord) {
        productNameLabel.text = productRecord.product_name!
        let format = ".2"
        quantityLabel.text = "x\(productRecord.quantity!)"
    }
}

class TMConsumeRecordDateCell: UITableViewCell {
    var dateLabel: UILabel!
    var amountLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    func configureData(order: TMOrder) {
        var date = order.register_time?.toString(format: .Custom("yyyy-MM-dd"))
        dateLabel.text = date
        let format = ".2"
        amountLabel.text = "\(order.actual_amount!.doubleValue.format(format))元"
        
    }
}
