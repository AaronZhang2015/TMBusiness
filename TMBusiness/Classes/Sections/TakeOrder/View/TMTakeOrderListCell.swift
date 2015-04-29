//
//  TMOrderListCell.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 3/9/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit
import Snap

protocol TMTakeOrderListCellDelegate: class {
    func orderListDidSubtract(product: TMProduct)
    
    func orderListDidPlus(product: TMProduct)
    
    func orderListDidDelete(product: TMProduct)
}

class TMTakeOrderListCell: UITableViewCell {
    
    var productNameLabel: UILabel!
    var subtractButton: UIButton!
    var plusButton: UIButton!
    var quantityLabel: UILabel!
    var priceLabel: UILabel!
    var deleteButton: UIButton!
    var product: TMProduct?
    
    weak var delegate: TMTakeOrderListCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIImageView(frame: bounds)
        selectedBackgroundView.backgroundColor = UIColor(hex: 0xF2F2F2)
        
        productNameLabel = UILabel(frame: CGRectMake(10, 14, 150, 21))
        productNameLabel.font = UIFont.systemFontOfSize(16)
        productNameLabel.text = "商品名称"
        addSubview(productNameLabel)
        
        subtractButton = UIButton.buttonWithType(.Custom) as! UIButton
        subtractButton.frame = CGRectMake(169, 7, 35, 35)
        subtractButton.setBackgroundImage(UIImage(named: "jian"), forState: .Normal)
        subtractButton.setBackgroundImage(UIImage(named: "jian_on"), forState: .Highlighted)
        subtractButton.addTarget(self, action: "handleSubtractAction", forControlEvents: .TouchUpInside)
        addSubview(subtractButton)
        
        plusButton = UIButton.buttonWithType(.Custom) as! UIButton
        plusButton.frame = CGRectMake(245, 7, 35, 35)
        plusButton.setBackgroundImage(UIImage(named: "jia"), forState: .Normal)
        plusButton.setBackgroundImage(UIImage(named: "jia_on"), forState: .Highlighted)
        plusButton.addTarget(self, action: "handlePlusAction", forControlEvents: .TouchUpInside)
        addSubview(plusButton)
        
        quantityLabel = UILabel(frame: CGRectMake(212, 14, 25, 21))
        quantityLabel.font = UIFont.systemFontOfSize(16)
        quantityLabel.textAlignment = .Center
        quantityLabel.text = "0"
        addSubview(quantityLabel)
        
        priceLabel = UILabel(frame: CGRectMake(297, 14, 87, 21))
        priceLabel.font = UIFont.systemFontOfSize(16)
        priceLabel.textAlignment = .Center
        priceLabel.text = "¥0.00"
        addSubview(priceLabel)
        
        deleteButton = UIButton.buttonWithType(.Custom) as! UIButton
        deleteButton.frame = CGRectMake(395, 14, 22, 22)
        deleteButton.setBackgroundImage(UIImage(named: "shuanchu"), forState: .Normal)
        deleteButton.setBackgroundImage(UIImage(named: "shuanchu_on"), forState: .Highlighted)
        deleteButton.addTarget(self, action: "handleDeleteAction", forControlEvents: .TouchUpInside)
        addSubview(deleteButton)
        
        var lineView = UIImageView(image: UIImage(named: "line"))
        lineView.top = 49
        addSubview(lineView)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureData(product: TMProduct) {
        editOrderData(false)
        self.product = product
        productNameLabel.text = product.product_name
        quantityLabel.text = NSString(format: "%zd", product.quantity.integerValue) as String
        priceLabel.text = NSString(format: "%.2f", product.official_quotation.doubleValue) as String
    }
    
    func editOrderData(edit: Bool) {
        subtractButton.hidden = !edit
        plusButton.hidden = !edit
        deleteButton.hidden = !edit
    }
    
    func handleSubtractAction() {
        if let delegate = self.delegate {
            delegate.orderListDidSubtract(product!)
        }
    }
    
    func handlePlusAction() {
        if let delegate = self.delegate {
            delegate.orderListDidPlus(product!)
        }
    }
    
    func handleDeleteAction() {
        if let delegate = self.delegate {
            delegate.orderListDidDelete(product!)
        }
    }
}
