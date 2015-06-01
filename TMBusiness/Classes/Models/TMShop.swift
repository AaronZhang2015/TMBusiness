//
//  TMUser.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 15/3/5.
//  Copyright (c) 2015年 ZhangMing. All rights reserved.
//

import UIKit

class TMShop: NSObject, NSCoding {
    
    // 商铺编号
    var shop_id: String!
    
    // 商户编号
    var business_id: String!
    
    // 商铺名称
    var shop_name: String?
    
    // LOGO宽度
    var width: NSNumber?
    
    // LOGO高度
    var height: NSNumber?
    
    // 商铺LOGO
    var logo_url: String?
    
    // 商铺地址
    var address: String?
    
    // 描述信息
    var shopDescription: String?
    
    // 开始时间
    var start_time: NSDate?
    
    // 结束时间
    var end_time: NSDate?
    
    // 签到奖励时间期限
    var deadline: NSNumber?
    
    // 消费奖励时间期限
    var deadline_consume: NSNumber?
    
    // 有效到访时间
    var residence_time: NSNumber?
    
    // 奖励迭代模式
    var combination: String!
    
    // T+0模式
    var immediate: String?
    
    // 商铺管理员编号
    var admin_id: String!
    
    // 商铺管理员姓名
    var admin_name: String?
    
    // 奖励信息实体
    var rewards: [TMReward]?
    
    class var sharedInstance: TMShop {
        struct Singleton {
            static let instance = TMShop()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(shop_id, forKey: "shop_id")
        aCoder.encodeObject(business_id, forKey: "business_id")
        aCoder.encodeObject(shop_name, forKey: "shop_name")
        aCoder.encodeObject(admin_id, forKey: "admin_id")
        aCoder.encodeObject(admin_name, forKey: "admin_name")
        aCoder.encodeObject(address, forKey: "address")
    }
    
    required init(coder aDecoder: NSCoder) {
        shop_id = aDecoder.decodeObjectForKey("shop_id") as! String
        business_id = aDecoder.decodeObjectForKey("business_id") as! String
        shop_name = aDecoder.decodeObjectForKey("shop_name") as? String
        admin_id = aDecoder.decodeObjectForKey("admin_id") as! String
        admin_name = aDecoder.decodeObjectForKey("admin_name") as? String
        address = aDecoder.decodeObjectForKey("address") as? String
    }
}
