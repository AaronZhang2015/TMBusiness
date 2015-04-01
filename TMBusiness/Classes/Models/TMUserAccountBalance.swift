//
//  TMUserAccountBalance.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 3/30/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import Foundation

/**
*  终端用户账户余额信息实体模型
*/
class TMUserAccountBalance: NSObject {
    // 账户余额
    var amount: NSNumber?
    
    // 商户编号
    var business_id: String?
}