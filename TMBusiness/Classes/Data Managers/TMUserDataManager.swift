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
    
    func fetchEntityAllInfo(condition: String, type: TMConditionType, shopId: String, businessId: String, adminId: String, completion: (TMUser?, NSError?) -> Void) {
        userService.fetchEntityAllInfo(condition, type: type, shopId: shopId, businessId: businessId, adminId: adminId, completion: completion)
    }
}
