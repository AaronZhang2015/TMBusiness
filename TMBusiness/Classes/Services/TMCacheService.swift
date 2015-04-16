//
//  TMConfigureService.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/16/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

enum TMCacheType: String {
    case Wifi = "wifi"  // wifi缓存
    case Category = "category_product"  // 商品缓存
}

class TMCacheService: NSObject {
    lazy var manager: TMNetworkManager = {
        return TMNetworkManager()
        }()
    
    func fetchCacheInfo(cacheType: TMCacheType, adminId: String, completion: (String?) -> Void) {
        manager.request(.POST, relativePath: "cache_getEntityWith", parameters: ["table_name": cacheType.rawValue, "extension_field": "", "admin_id": adminId, "device_type": AppManager.platform().rawValue]) { (result) -> Void in
            switch result {
            case let .Error(e):
                completion(nil)
            case let .Value(json):
                // 解析数据
                let data = json["data"]
                let cacheId = data["cache_id"].string
                completion(cacheId)
            }
        }
    }
}
