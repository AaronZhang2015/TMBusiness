//
//  TMOrderProductListView.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/28/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import Snap

let TMOrderProductDetailProductCellIdentifier = "TMOrderProductDetailProductCell"
class TMOrderProductListView: UIView {
    
    var data: TMOrder! {
        didSet {
            productListTableView.reloadData()
        }
    }

    lazy var separatorView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "checking_account_separator"))
        return imageView
        }()
    
    lazy var bgView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
        }()
    
    lazy var boxImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "order_product_list_bg"))
        return imageView
        }()
    
    var orderNoTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "订单编号"
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor(hex: 0x222222)
        return label
        }()
    
    var orderNoLabel: UILabel = {
        var label = UILabel()
        label.text = "201502121212"
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor(hex: 0x438EB8)
        return label
        }()
    
    lazy var restingOrderMenuView: TMRestingOrderMenuView = {
        var menuView = TMRestingOrderMenuView()
        
        return menuView
        }()
    
    lazy var waitForPayingMenuView: TMWaitForPayingMenuView = {
        var menuView = TMWaitForPayingMenuView()
        
        return menuView
        }()
    
    lazy var transactionDoneMenuView: TMTransactionDoneMenuView = {
        var menuView = TMTransactionDoneMenuView()
        
        return menuView
        }()
    
    var detailView: TMOrderProductDetailView = {
        var view = TMOrderProductDetailView()
        
        return view
        }()
    
    lazy var boxView: UIView = {
        var view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: 0xD4D4D4).CGColor
        return view
        }()
    
    // 商品列表
    lazy var productListTableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.registerClass(TMOrderProductDetailProductCell.self, forCellReuseIdentifier: TMOrderProductDetailProductCellIdentifier)
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.separatorStyle = .None
        return tableView
        }()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
//        addSubview(separatorView)
//        separatorView.snp_makeConstraints { (make) -> Void in
//            make.leading.equalTo(0)
//            make.top.equalTo(0)
//            make.width.equalTo(10)
//            make.bottom.equalTo(0)
//        }
//
//        addSubview(bgView)
//        bgView.snp_makeConstraints { (make) -> Void in
//            make.leading.equalTo(10)
//            make.top.equalTo(0)
//            make.trailing.equalTo(0)
//            make.bottom.equalTo(0)
//        }
        
        addSubview(boxImageView)
        boxImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(17)
            make.leading.equalTo(18)
            make.trailing.equalTo(-9)
            make.bottom.equalTo(-44)
        }
        
        addSubview(orderNoTitleLabel)
        orderNoTitleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(boxImageView.snp_leading).offset(20)
            make.top.equalTo(boxImageView.snp_top).offset(18)
            make.height.equalTo(19)
            make.width.equalTo(80)
        }
        
        addSubview(orderNoLabel)
        orderNoLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(orderNoTitleLabel.snp_trailing).offset(20)
            make.top.equalTo(orderNoTitleLabel.snp_top)
            make.trailing.equalTo(boxImageView.snp_trailing).offset(-20)
            make.height.equalTo(orderNoTitleLabel.snp_height)
        }
        
        
        // 挂单按钮
        /*
        addSubview(restingOrderMenuView)
        restingOrderMenuView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(boxImageView.snp_bottom)
            make.height.equalTo(105)
            make.leading.equalTo(boxImageView.snp_leading).offset(20)
            make.trailing.equalTo(boxImageView.snp_trailing).offset(-20)
        }
        */
        
        
        // 待支付按钮
        /*
        addSubview(waitForPayingMenuView)
        waitForPayingMenuView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(boxImageView.snp_bottom)
            make.height.equalTo(105)
            make.leading.equalTo(boxImageView.snp_leading).offset(20)
            make.trailing.equalTo(boxImageView.snp_trailing).offset(-20)
        }
        */
        
        
        // 交易完成按钮
        addSubview(transactionDoneMenuView)
        transactionDoneMenuView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(boxImageView.snp_bottom)
            make.height.equalTo(105)
            make.leading.equalTo(boxImageView.snp_leading).offset(20)
            make.trailing.equalTo(boxImageView.snp_trailing).offset(-20)
        }
        
        // 订单金额明细
        addSubview(detailView)
        detailView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(transactionDoneMenuView.snp_top)
            make.height.equalTo(100)
            make.leading.equalTo(boxImageView.snp_leading).offset(20)
            make.trailing.equalTo(boxImageView.snp_trailing).offset(-20)
        }
        
        addSubview(boxView)
        boxView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(orderNoTitleLabel.snp_bottom).offset(10)
            make.leading.equalTo(28)
            make.trailing.equalTo(-28)
            make.bottom.equalTo(detailView.snp_top)
        }
        
        addSubview(productListTableView)
        productListTableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(boxView.snp_edges)
        }
    }
    
    func configureViewData() {
        
    }
}

extension TMOrderProductListView: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let order = self.data where order.product_records.count > 0 {
            return order.product_records.count + 1
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TMOrderProductDetailProductCellIdentifier, forIndexPath: indexPath) as! TMOrderProductDetailProductCell
        if let order = data where order.product_records.count > 0  {
            
            if indexPath.row <= order.product_records.count - 1 {
                var productRecord = order.product_records[indexPath.row]
                cell.configureData(productRecord)
            }
        }
        return cell
    }
}

extension TMOrderProductListView: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        <#code#>
    }
}


class TMOrderProductDetailProductCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor(hex: 0x222222)
        label.text = "久留米寿司"
        return label
        }()
    
    lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor(hex: 0x222222)
        label.textAlignment = .Right
        label.text = "¥50.00"
        return label
        }()
    
    lazy var quantityLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor(hex: 0x222222)
        label.textAlignment = .Center
        label.text = "20"
        return label
        }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        
        // 商品名称
        addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(15)
            make.height.equalTo(22)
            make.width.equalTo(180)
            make.centerY.equalTo(snp_centerY)
        }
        
        // 数量
        addSubview(quantityLabel)
        quantityLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(nameLabel.snp_trailing).offset(2)
            make.centerY.equalTo(snp_centerY)
            make.height.equalTo(22)
            make.width.equalTo(68)
        }
        
        // 单价
        addSubview(priceLabel)
        priceLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(quantityLabel.snp_trailing)
            make.centerY.equalTo(snp_centerY)
            make.height.equalTo(22)
            make.trailing.equalTo(snp_trailing).offset(-10)
        }
        
    }
    
    func configureData(data: TMProductRecord) {
        nameLabel.text = data.product_name
        quantityLabel.text = "\(data.quantity.integerValue)"
        let format = ".2"
        priceLabel.text = "\(data.price.doubleValue.format(format))"
    }
}

class TMOrderProductDetailProductHeaderView: UIView {
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
