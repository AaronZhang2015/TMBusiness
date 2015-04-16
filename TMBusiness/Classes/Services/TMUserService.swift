//
//  TMUserService.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 15/3/5.
//  Copyright (c) 2015年 ZhangMing. All rights reserved.
//

import UIKit
import Alamofire

enum TMConditionType: Int {
    case MobileNumber = 1
    case UserId = 2
}

class TMUserService: NSObject {
    
    lazy var manager: TMNetworkManager = {
        return TMNetworkManager()
    }()
   
    // 商户用户登录
    func login(username: String , password: String, completion: (TMShop?, NSError?) -> Void) {
        manager.request(.POST, relativePath: "shop_login", parameters: ["login_account" : username, "login_password" : password, "device_type" : AppManager.platform().rawValue]) { (result) -> Void in
            switch result {
            case let .Error(e):
                completion(nil, e)
            case let .Value(json):
                // 解析数据
                let data = json["data"]
                
                var shop = TMShop.sharedInstance
                shop.shop_id = data["shop_id"].stringValue
                shop.shop_name = data["shop_name"].stringValue
                shop.admin_id = data["admin_id"].stringValue
                shop.address = data["address"].string
                shop.business_id = data["business_id"].stringValue
                
                completion(shop, nil)
            }
        }
    }
    
    // 获取用户基本信息
    func fetchUserInfo() {
        manager.request(.POST, relativePath: "user_getEntityDetailInfo", parameters: ["user_id": TMShop.sharedInstance.admin_id!, "device_type" : AppManager.platform().rawValue]) { (result) -> Void in
            switch result {
            case let .Error(e):
                println(e)
            case let .Value(json):
                // 解析数据
                let data = json["data"]
                println(data)
            }
            
        }
    }
    
    func fetchEntityAllInfo(condition: String, type: TMConditionType, shopId: String, businessId: String, adminId: String) {
        manager.request(.POST, relativePath: "user_getEntityAllInfo", parameters: ["condition": condition, "type": type.rawValue, "shop_id": shopId, "business_id": businessId, "admin_id": adminId, "device_type" : AppManager.platform().rawValue]) { (result) -> Void in
            switch result {
            case let .Error(e):
                println(e)
            case let .Value(json):
                // 解析数据
                let data = json["data"]
                
                var user = TMUser()
                user.user_id = data["user_id"].string
                user.real_name = data["real_name"].string
                user.nick_name = data["nick_name"].string
                user.landline_number = data["landline_number"].string
                user.mobile_number = data["mobile_number"].string
                user.qq = data["qq"].string
                user.email = data["email"].string
                user.province = data["province"].string
                user.city = data["city"].string
                user.weixin = data["weixin"].string
                user.weibo = data["weibo"].string
                user.renren = data["renren"].string
                user.head_image = data["head_image"].string
                
                // 解析用户余额
                var userAccountBalance: TMUserAccountBalance?
                var user_account_balance = data["user_account_balance"]
                if  user_account_balance != nil {
                    userAccountBalance = TMUserAccountBalance()
                    userAccountBalance!.amount = user_account_balance["amount"].number
                    userAccountBalance!.business_id = user_account_balance["business_id"].string
                }
                
                // 解析充值记录
                var rechargeRecord: [TMRechargeRecord]?
                var recharge_record = data["recharge_record"]
                
                println("user_account_balance = \(user_account_balance)")
                
                println(data)
            }
        }
    }
}
