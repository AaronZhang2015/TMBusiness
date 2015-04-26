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
   
    
    func addOrderEntityInfo(#userId: String, shopId: String, transactionMode: TMTransactionMode, registerType: TMRegisterType, payableAmount: NSNumber, actualAmount: NSNumber, couponId: String, discount: String, discountType: TMDiscountType, description: String, businessId: String, orderStatus: TMOrderStatus, productList: [TMProductRecord], adminId: String, completion:(String?, NSError?) -> Void) {
        let format = ".2"
        var productListJsonString = "["
        // 拼接商品内容
        for var index = 0; index < productList.count; ++index {
            var product = productList[index]
            if let product_id = product.product_id {
                var productString = "{\"product_id\":\"\(product.product_id!)\", \"quantity\":\"\(product.quantity.integerValue)\", \"price\":\"\(product.price.doubleValue.format(format))\"}"
                
                productListJsonString = "\(productListJsonString)\(productString)"
                println(productString)
            }
            
            if index != productList.count - 1 {
                productListJsonString = "\(productListJsonString),"
            }
        }
        productListJsonString = "\(productListJsonString)]"
        
        var parameters = ["user_id": userId,
            "shop_id": shopId,
            "transaction_mode": "\(transactionMode.rawValue)",
            "register_type": "\(registerType.rawValue)",
            "payable_amount": "\(payableAmount.doubleValue.format(format))",
            "actual_amount": "\(actualAmount.doubleValue.format(format))",
            "coupon_id": couponId,
            "discount": discount,
            "discount_type": "\(discountType.rawValue)",
            "description": description,
            "business_id": businessId,
            "order_status": "\(orderStatus.rawValue)",
            "product_model_json": productListJsonString,
            "admin_id": adminId,
            "device_type": "\(AppManager.platform().rawValue)"]
        
        manager.request(.POST, relativePath: "order_addEntityInfo", parameters: parameters) { (result) -> Void in
            switch result {
            case let .Error(e):
                completion(nil, e)
            case let .Value(json):
                // 解析数据
                let data = json["data"]
                completion(data["order_id"].string, nil)
            }
        }
    }
    
//    func updateOrderStatus(status: TMOrderStatus, orderId: )
}
