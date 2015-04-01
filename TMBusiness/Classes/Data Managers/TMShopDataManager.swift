//
//  TMShopDataManager.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 3/30/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit

/**
*  商户的数据
*/
class TMShopDataManager: TMDataManager {
    lazy var shopService: TMShopService = {
        return TMShopService()
        }()
    
    /**
    获取商铺分类列表以及分类下的商品列表
    
    :param: shopId     商铺编号
    :param: completion 如果请求正常，返回分类列表，否则返回错误
    */
    func fetchEntityProductList(shopId: String, completion: ([TMCategory]?, NSError?) -> Void) {
        
        // 首先判断本地数据库是否有数据
        // 如果有数据那么就从本地获取
        
        
        // 否则就从网络请求，并缓存本地
        shopService.fetchEntityProductList(shopId, completion: completion)
        
    }
}
