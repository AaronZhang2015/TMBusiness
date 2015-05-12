//
//  TMUserDataManager.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/17/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

class TMUserDataManager: TMDataManager {
    lazy var userService: TMUserService = {
        return TMUserService()
        }()
    
    /**
    根据终身号、商铺编号、奖励类型获取该会员当前及下阶段奖励，及当前商铺所有奖励信息
    
    :param: condition  手机号码或终身号
    :param: type       手机号码或者终身号类型区分
    :param: shopId     商铺编号
    :param: businessId 商户编号
    :param: adminId    商铺管理员编号
    :param: completion 回调
    */
    func fetchEntityAllInfo(condition: String, type: TMConditionType, shopId: String, businessId: String, adminId: String, isEncrypt: Bool = false, completion: (TMUser?, NSError?) -> Void) {
        userService.fetchEntityAllInfo(condition, type: type, shopId: shopId, businessId: businessId, adminId: adminId, extensionField: isEncrypt ? "B": "", completion: completion)
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
    func doUserRecharge(rechargeId: String = "", userId: String, rewardId: String = "", totalAmount: NSNumber, actualAmount: NSNumber, actualType: TMRechargeType, flag: TMRechargeFlag = .Recharge, shopId: String, businessId: String, errorStatus: String = "", recommendCode: String = "", adminId: String = "", completion: (String?, NSError?) -> Void) {
        userService.doUserRecharge(rechargeId, userId: userId, rewardId: rewardId, totalAmount: totalAmount, actualAmount: actualAmount, actualType: actualType, flag: flag, shopId: shopId, businessId: businessId, errorStatus: errorStatus, recommendCode: recommendCode, adminId: adminId) { [weak self] (recharge_id, error) -> Void in
            if let strongSelf = self {
                if let e = error {
                    // 错误
                    completion(nil, e)
                } else {
                    completion(recharge_id, nil)
//                    strongSelf.userService.doUserRecharge(recharge_id!, userId: userId, rewardId: rewardId, totalAmount: totalAmount, actualAmount: actualAmount, actualType: actualType, flag: flag, shopId: shopId, businessId: businessId, errorStatus: errorStatus, recommendCode: recommendCode, adminId: adminId, completion: { (_, error) -> Void in
//                        completion(error)
//                    })
                }
            }
        }
    }
    
    func doUserRechargeWithCash(rechargeId: String = "", userId: String, rewardId: String = "", totalAmount: NSNumber, actualAmount: NSNumber, actualType: TMRechargeType, flag: TMRechargeFlag = .Recharge, shopId: String, businessId: String, errorStatus: String = "", recommendCode: String = "", adminId: String = "", completion: (NSError?) -> Void) {
        userService.doUserRecharge(rechargeId, userId: userId, rewardId: rewardId, totalAmount: totalAmount, actualAmount: actualAmount, actualType: actualType, flag: flag, shopId: shopId, businessId: businessId, errorStatus: errorStatus, recommendCode: recommendCode, adminId: adminId) { [weak self] (recharge_id, error) -> Void in
            if let strongSelf = self {
                if let e = error {
                    // 错误
                    completion(e)
                } else {
                    strongSelf.userService.doUserRecharge(recharge_id!, userId: userId, rewardId: rewardId, totalAmount: totalAmount, actualAmount: actualAmount, actualType: actualType, flag: flag, shopId: shopId, businessId: businessId, errorStatus: errorStatus, recommendCode: recommendCode, adminId: adminId, completion: { (_, error) -> Void in
                        completion(error)
                    })
                }
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
    func fetchUserEntityOrder(shopId: String, businessId: String = "", type: TMShopType = .Shop, userId: String, startIndex: Int, pageSize: Int = 10, adminId: String, completion: ([TMOrder]?, NSError?) -> Void) {
        userService.fetchUserOrderList(shopId, businessId: businessId, type: type, userId: userId, startIndex: startIndex, pageSize: pageSize, adminId: adminId, completion: completion)
    }
    
    
    func fetchUserEntityOrderList(condition: String, conditionType: TMConditionType, startTime: String = "", endTime: String = "", searchType: TMSearchType = .All, orderStatus: TMOrderStatus, orderPageIndex: Int, orderPageSize: Int = 10, showProductRecord: String = "1", productRecordPageIndex: String = "", productRecordPageSize: String = "", adminId: String, completion: ([TMOrder]?, NSError?) -> Void) {
        
        userService.fetchUserEntityOrderList(condition, conditionType: conditionType, startTime: startTime, endTime: endTime, searchType: searchType, orderStatus: orderStatus, orderPageIndex: "\(orderPageIndex)", orderPageSize: "\(orderPageSize)", showProductRecord: showProductRecord, productRecordPageIndex: productRecordPageIndex, productRecordPageSize: productRecordPageSize, adminId: adminId, completion: completion)
    }
    
    func fetchBoxPayEntityInfo(sn: String, extensionField: String = "", businessId: String = "", shopId: String = "", adminId: String = "", completion: (TMBoxPay?, NSError?) -> Void) {
        userService.fetchBoxPayEntityInfo(sn, extensionField: extensionField, businessId: businessId, shopId: shopId, adminId: adminId, completion: completion)
    }

}
