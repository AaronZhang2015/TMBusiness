//
//  TMOrderService.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 15/3/5.
//  Copyright (c) 2015年 ZhangMing. All rights reserved.
//

import UIKit

enum TMOrderStatus: Int {
    case Take = 1
    case WaitForPaying = 2
    case PaySuccess = 3
    case Dispatching = 4
    case TransactionDone = 5
    case Invalid = 8
}

enum TMRegisterType: Int {
    case Manually = 1
    case Auto = 2
}

class TMOrderService: NSObject {
    lazy var manager: TMNetworkManager = {
        return TMNetworkManager()
        }()
   
    
    func addOrderEntityInfo(userId: String, shopId: String, transactionMode: TMTransactionMode, registerType: TMRegisterType, payableAmount: NSNumber, actualAmount: NSNumber, couponId: String = "", discount: String = "", discountType: String = "", description: String = "", businessId: String, orderStatus: TMOrderStatus, productList: [TMProduct], adminId: String) {
        let format = ".2"
        // 拼接商品内容
//        var json: JSON = JSON()
        for product in productList {
            var subjson:JSON = ["product_id": product.product_id!, "quantity": "\(product.quantity.integerValue)", "price": "\(product.official_quotation.doubleValue.format(format))"]
        }
    }
    
//    func updateOrderStatus(status: TMOrderStatus, orderId: )
}
