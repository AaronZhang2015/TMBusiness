//
//  TMUser.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 15/3/5.
//  Copyright (c) 2015年 ZhangMing. All rights reserved.
//

import UIKit

class TMShop: NSObject {
    
    // 商铺编号
    var shop_id: String?
    
    // 商户编号
    var business_id: String?
    
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
    
    // 商铺管理员编号
    var admin_id: String?
    
    
    class var sharedInstance: TMShop {
        struct Singleton {
            static let instance = TMShop()
        }
        return Singleton.instance
    }
    
}

/*
shop_id										商铺编号
business_id									商户编号
shop_name									商铺名称
logo_url										商铺LOGO
width										LOGO宽度
height										LOGO高度
address										地址
description									描述信息
start_time									开始时间
end_time										结束时间
images										图片集
type											商户类型（0：景点 1：会展 2：博物馆													3：餐厅 4：服装）
longitude										经度
latitude										纬度
isAttention									是否被关注（0：未关注  1：被关注）
distance										距离（千米）
deadline										签到奖励时间期限
deadline_consume								消费奖励时间期限
residence_time								有效到访时间
navigation_image								导游图
rewards										奖励信息实体
business_partner								合作者身份ID
business_seller								卖家支付宝账号
business_rsa_private							rsa私钥
business_rsa_public							rsa公钥
admin_id										商铺管理员编号
*/

/*
"description" : null,
"address" : "南京市鼓楼区洪武路160号(羊皮巷口，华仔隔壁) ",
"isAttention" : null,
"business_id" : "201412291911000001",
"business_rsa_private" : null,
"images" : null,
"logo_url" : null,
"latitude" : null,
"rewards" : null,
"business_seller" : null,
"admin_id" : "201412301313000001",
"type" : null,
"deadline_consume" : null,
"longitude" : null,
"residence_time" : null,
"height" : null,
"distance" : null,
"width" : null,
"deadline" : null,
"start_time" : null,
"business_partner" : null,
"end_time" : null,
"business_rsa_public" : null,
"navigation_image" : null,
"shop_name" : "韩国厨房",
"shop_id" : "201412301313000001"
*/