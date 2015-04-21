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
    func fetchEntityAllInfo(condition: String, type: TMConditionType, shopId: String, businessId: String, adminId: String, completion: (TMUser?, NSError?) -> Void) {
        userService.fetchEntityAllInfo(condition, type: type, shopId: shopId, businessId: businessId, adminId: adminId, completion: completion)
    }
}
