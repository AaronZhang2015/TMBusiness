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
    
    func fetchEntityAllInfo(condition: String, type: TMConditionType, shopId: String, businessId: String, adminId: String, completion: (TMUser?, NSError?) -> Void) {
        manager.request(.POST, relativePath: "user_getEntityAllInfo", parameters: ["condition": condition, "type": type.rawValue, "shop_id": shopId, "business_id": businessId, "admin_id": adminId, "device_type" : AppManager.platform().rawValue]) { (result) -> Void in
            switch result {
            case let .Error(e):
                completion(nil, e)
            case let .Value(json):
                // 解析数据
                let data = json["data"]
                var user = TMParser.parseUser(data)
                completion(user, nil)
            }
        }
    }
}
