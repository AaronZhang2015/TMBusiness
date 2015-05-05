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
let TMOrderProductDetailProductRemarkCellIdentifier = "TMOrderProductDetailProductRemarkCell"

class TMOrderProductListView: UIView {
    
    var data: TMOrder! {
        didSet {
            configureViewData()
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
        tableView.registerClass(TMOrderProductDetailProductRemarkCell.self, forCellReuseIdentifier: TMOrderProductDetailProductRemarkCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        tableView.separatorStyle = .None
        return tableView
        }()
    
    var cancelOrderClosure: (TMOrder -> Void)?
    var printOrderClosure: (TMOrder -> Void)?
    var checkoutOrderClosure: (TMOrder -> Void)?
    var takeOrderClosure: (TMOrder -> Void)?
//    var printOrderClosure: (TMOrder -> Void)?
    
    
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
        
        addSubview(restingOrderMenuView)
        restingOrderMenuView.cancelButton.addTarget(self, action: "handleCancelAction", forControlEvents: .TouchUpInside)
        restingOrderMenuView.takeOrderButton.addTarget(self, action: "handleTakeOrderAction", forControlEvents: .TouchUpInside)
        restingOrderMenuView.checkOutButton.addTarget(self, action: "handleCheckoutAction", forControlEvents: .TouchUpInside)
        restingOrderMenuView.hidden = true
        restingOrderMenuView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(boxImageView.snp_bottom)
            make.height.equalTo(105)
            make.leading.equalTo(boxImageView.snp_leading).offset(20)
            make.trailing.equalTo(boxImageView.snp_trailing).offset(-20)
        }
        
        
        // 待支付按钮
        
        addSubview(waitForPayingMenuView)
        waitForPayingMenuView.printButton.addTarget(self, action: "handlePrintAction", forControlEvents: .TouchUpInside)
        waitForPayingMenuView.checkoutButton.addTarget(self, action: "handleCheckoutAction", forControlEvents: .TouchUpInside)
        waitForPayingMenuView.hidden = true
        waitForPayingMenuView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(boxImageView.snp_bottom)
            make.height.equalTo(105)
            make.leading.equalTo(boxImageView.snp_leading).offset(20)
            make.trailing.equalTo(boxImageView.snp_trailing).offset(-20)
        }
        
        // 交易完成按钮
        addSubview(transactionDoneMenuView)
        transactionDoneMenuView.printButton.addTarget(self, action: "handlePrintAction", forControlEvents: .TouchUpInside)
        transactionDoneMenuView.hidden = true
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
            make.top.equalTo(boxView.snp_top).offset(1)
            make.leading.equalTo(29)
            make.trailing.equalTo(-29)
            make.bottom.equalTo(boxView.snp_bottom).offset(-1)
        }
    }
    
    func configureViewData() {
        productListTableView.reloadData()
        
        if let order = data {
            let format = ".2"
            let discountFormat = ".1"
            // 优惠折扣
            if let discount = order.discount {
                var discountRate = (discount.doubleValue * 10).format(discountFormat)
                detailView.discountAmountLabel.text = "\(discountRate)折"
            }
            
            // 消费金额
            detailView.consumeLabel.text = "¥\(order.payable_amount.doubleValue.format(format))"
            
            // 优惠金额
            var discountAmount = order.payable_amount.doubleValue - order.actual_amount.doubleValue
            detailView.discountLabel.text = "¥\(discountAmount.format(format))"
            
            // 折后金额
            detailView.actualLabel.text = "¥\(order.actual_amount.doubleValue.format(format))"
            
            // 编号
            if let orderId = order.order_id {
                orderNoLabel.text = orderId
            }
            
            // 挂单
            if order.status == .Resting {
                orderNoTitleLabel.hidden = true
                orderNoLabel.hidden = true
            } else {
                orderNoTitleLabel.hidden = false
                orderNoLabel.hidden = false
            }
            
            // 设置页面状态
            // 待支付
            restingOrderMenuView.hidden = true
            waitForPayingMenuView.hidden = true
            transactionDoneMenuView.hidden = true
            
            if order.status == TMOrderStatus.WaitForPaying {
                waitForPayingMenuView.hidden = false
            } else if order.status == TMOrderStatus.TransactionDone {
                transactionDoneMenuView.hidden = false
            } else {
                restingOrderMenuView.hidden = false
            }
        }
        
    }
    
    /**
    取消挂单
    */
    func handleCancelAction() {
        if let closure = cancelOrderClosure {
            closure(data)
        }
    }
    
    
    /**
    打印
    */
    func handlePrintAction() {
        if let closure = printOrderClosure {
            closure(data)
        }
    }
    
    /**
    结账
    */
    func handleCheckoutAction() {
        if let closure = checkoutOrderClosure {
            closure(data)
        }
    }
    
    /**
    下单
    */
    func handleTakeOrderAction() {
        if let closure = takeOrderClosure {
            closure(data)
        }
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
        if let order = data where order.product_records.count > 0  {
            
            if indexPath.row <= order.product_records.count - 1 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier(TMOrderProductDetailProductCellIdentifier, forIndexPath: indexPath) as! TMOrderProductDetailProductCell
                cell.selectionStyle = .None
                var productRecord = order.product_records[indexPath.row]
                cell.configureData(productRecord)
                
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TMOrderProductDetailProductRemarkCellIdentifier, forIndexPath: indexPath) as! TMOrderProductDetailProductRemarkCell
        cell.selectionStyle = .None
        if let remark = data.order_description {
            cell.configureData(remark)
        }
        
        return cell
    }
}

extension TMOrderProductListView: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = TMOrderProductDetailProductHeaderView()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let order = data where order.product_records.count > 0  {
            if indexPath.row == order.product_records.count {
                return heightForRemarkCell()
            }
        }
        
        return 50.0
    }
    
    func heightForRemarkCell() -> CGFloat {
        let sizingCell = productListTableView.dequeueReusableCellWithIdentifier(TMOrderProductDetailProductRemarkCellIdentifier) as! TMOrderProductDetailProductRemarkCell
        if let remark = data.order_description {
            sizingCell.configureData(remark)
        }
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        var size = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        
        var height = (size.height + 1.0)  - 25
        // TODO
        return  height < 50 ? 50 : height
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
    
    var dashView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "checking_account_dash_line"))
        return imageView
        }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 商品名称
        contentView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(15)
            make.height.equalTo(22)
            make.width.equalTo(180)
            make.centerY.equalTo(snp_centerY)
        }
        
        // 数量
        contentView.addSubview(quantityLabel)
        quantityLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(nameLabel.snp_trailing).offset(2)
            make.centerY.equalTo(snp_centerY)
            make.height.equalTo(22)
            make.width.equalTo(68)
        }
        
        // 单价
        contentView.addSubview(priceLabel)
        priceLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(quantityLabel.snp_trailing)
            make.centerY.equalTo(snp_centerY)
            make.height.equalTo(22)
            make.trailing.equalTo(snp_trailing).offset(-10)
        }
        
        contentView.addSubview(dashView)
        dashView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(1)
        }
    }
    
    func configureData(data: TMProductRecord) {
        nameLabel.text = data.product_name
        quantityLabel.text = "\(data.quantity.integerValue)"
        let format = ".2"
        priceLabel.text = "¥\(data.price.doubleValue.format(format))"
    }
}

class TMOrderProductDetailProductRemarkCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor(hex: 0x222222)
        label.text = "备注："
        return label
        }()
    
    lazy var remarkLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.textColor = UIColor(hex: 0x222222)
        label.numberOfLines = 0
        label.text = "备注："
        return label
        }()
    
    var dashView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "checking_account_dash_line"))
        return imageView
        }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(15)
            make.height.equalTo(22)
            make.width.equalTo(60)
            make.top.equalTo(14)
        }
        
        contentView.addSubview(remarkLabel)
        remarkLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(nameLabel.snp_trailing).offset(6)
            make.bottom.equalTo(-14)
            make.trailing.equalTo(-15)
            make.top.equalTo(14)
        }
        
        contentView.addSubview(dashView)
        dashView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        remarkLabel.preferredMaxLayoutWidth = CGRectGetWidth(remarkLabel.frame)
    }
    
    func configureData(remark: String) {
        remarkLabel.text = remark
    }
}

class TMOrderProductDetailProductHeaderView: UIView {
    
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(18)
        label.textColor = UIColor(hex: 0x222222)
        label.text = "名称"
        return label
        }()
    
    lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(18)
        label.textColor = UIColor(hex: 0x222222)
        label.textAlignment = .Center
        label.text = "数量"
        return label
        }()
    
    lazy var quantityLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(18)
        label.textColor = UIColor(hex: 0x222222)
        label.textAlignment = .Right
        label.text = "单价"
        return label
        }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        
        addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(40)
            make.height.equalTo(18)
            make.width.equalTo(40)
            make.centerY.equalTo(snp_centerY)
        }
        
        addSubview(priceLabel)
        priceLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(195)
            make.height.equalTo(18)
            make.width.equalTo(68)
            make.centerY.equalTo(snp_centerY)
        }
        
        addSubview(quantityLabel)
        quantityLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(265)
            make.height.equalTo(18)
            make.trailing.equalTo(snp_trailing).offset(-10)
            make.centerY.equalTo(snp_centerY)

        }
    }
}
