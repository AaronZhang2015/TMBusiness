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

enum TMRechargeType: Int {
    case Cash = 1
}

enum TMRechargeFlag: Int {
    case Recharge = 1
    case Withdraw = 2
}

enum TMShopType: Int {
    case Business = 1
    case Shop = 2
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
    
    /**
    根据终身号、商铺编号、奖励类型获取该会员当前及下阶段奖励，及当前商铺所有奖励信息
    
    :param: condition  手机号码或终身号
    :param: type       手机号码或者终身号类型区分
    :param: shopId     商铺编号
    :param: businessId 商户编号
    :param: adminId    商铺管理员编号
    :param: extensionField    是否解密（值为“B”时用户终生号需传加密过的，服务器会去解密.不传该参数时用户终生号不要传加密过的，服务器将不去解密。）
    :param: completion 回调
    */
    func fetchEntityAllInfo(condition: String, type: TMConditionType, shopId: String, businessId: String, adminId: String, extensionField: String, completion: (TMUser?, NSError?) -> Void) {
        manager.request(.POST, relativePath: "user_getEntityAllInfo", parameters: ["condition": condition, "type": type.rawValue, "shop_id": shopId, "business_id": businessId, "admin_id": adminId, "device_type" : AppManager.platform().rawValue, "extension_field": extensionField]) { (result) -> Void in
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
    
    /**
    会员充值接口
    
    :param: rechargeId    充值单号
    :param: userId        用户终身号
    :param: rewardId      奖励设置编号
    :param: totalAmount   到账金额
    :param: actualAmount  实际充值金额
    :param: actualType    充值方式1：现金 2：支付宝3：网银支付 4：盒子支付 9：其他（默认2，不必填）
    :param: flag          记录表示 1：充值 2：提现（默认1，不必填）
    :param: shopId        商铺编号
    :param: businessId    商户编号
    :param: errorStatus   支付状态
    :param: recommendCode 推荐人编码
    :param: adminId       商铺管理员编号
    :param: completion 回调
    */
    func doUserRecharge(rechargeId: String, userId: String, rewardId: String, totalAmount: NSNumber, actualAmount: NSNumber, actualType: TMRechargeType, flag: TMRechargeFlag, shopId: String, businessId: String, errorStatus: String, recommendCode: String, adminId: String, completion: (String?, NSError?) -> Void) {
        
        let privateKey = String.generateString(8)
        let publicKey = "$Xunmi21"
        var parameters = ["key": Crypto.DesEncrypt(privateKey, keyStr: publicKey),
            "recharge_id": Crypto.DesEncrypt(rechargeId, keyStr: privateKey),
        "user_id": Crypto.DesEncrypt(userId, keyStr: privateKey),
        "reward_id": Crypto.DesEncrypt(rewardId, keyStr: privateKey),
        "total_amount": Crypto.DesEncrypt("\(totalAmount)", keyStr: privateKey),
        "actual_amount": Crypto.DesEncrypt("\(actualAmount)", keyStr: privateKey),
        "actual_type": Crypto.DesEncrypt("\(actualType.rawValue)", keyStr: privateKey),
        "flag": Crypto.DesEncrypt("\(flag.rawValue)", keyStr: privateKey),
        "shop_id": Crypto.DesEncrypt(shopId, keyStr: privateKey),
        "business_id": Crypto.DesEncrypt(businessId, keyStr: privateKey),
        "error_status": Crypto.DesEncrypt(errorStatus, keyStr: privateKey),
        "extension_field": Crypto.DesEncrypt(recommendCode, keyStr: privateKey),
        "admin_id": Crypto.DesEncrypt(adminId, keyStr: privateKey),
        "device_type": Crypto.DesEncrypt("\(AppManager.platform().rawValue)", keyStr: privateKey)]
        
        manager.request(.POST, relativePath: "user_recharge", parameters: parameters) { (result) -> Void in
            switch result {
            case let .Error(e):
                completion(nil, e)
            case let .Value(json):
                // 解析数据
                let data = json["data"]
                var rechargeId = data["recharge_id"].number
                completion(rechargeId?.stringValue, nil)
            }
        }
    }
    
    /**
    根据终身号、商铺编号、商户编号获取该品牌下所有的消费记录或该品牌下某商铺的消费记录
    
    :param: shopId     商铺编号
    :param: businessId 商户编号
    :param: type       是商铺到访，还是商户到访
    :param: userId     用户终身号
    :param: startIndex 起始记录条数
    :param: pageSize   每页多少条记录，默认10条
    :param: adminId    管理员编号
    */
    func fetchUserOrderList(shopId: String, businessId: String = "", type: TMShopType = .Shop, userId: String, startIndex: Int, pageSize: Int = 10, adminId: String, completion: ([TMOrder]?, NSError?) -> Void) {
        var parameters = ["shop_id": shopId,
            "business_id": businessId,
            "type": "\(type.rawValue)",
            "user_id": userId,
            "page_index": "\(startIndex)",
            "page_size": "\(pageSize)",
            "admin_id": adminId,
            "device_type" : "\(AppManager.platform().rawValue)"]
        
        manager.request(.POST, relativePath: "user_getEntityOrder", parameters: parameters) { (result) -> Void in
            switch result {
            case let .Error(e):
                completion(nil, e)
            case let .Value(json):
                // 解析数据
                let data = json["data"]
                
                var orderList = [TMOrder]()
                for (index: String, subJson: JSON) in data {
                    var order = TMParser.parseOrder(subJson)
                    orderList.append(order)
                }
                completion(orderList, nil)
            }
        }
    }
}
