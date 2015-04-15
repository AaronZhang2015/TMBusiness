//
//  TMShopDataManager.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 3/30/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit
import CoreData

/**
*  商户的数据
*/
class TMShopDataManager: TMDataManager {
    lazy var shopService: TMShopService = {
        return TMShopService()
        }()
    
    /**
    商家登录
    
    :param: username   用户名or手机号
    :param: password   密码
    :param: completion 如果请求正常，返回商铺信息，否则返回错误
    */
    func login(username: String, password: String, completion: (TMShop?, NSError?) -> Void) {
        shopService.login(username, password: password, completion: completion)
    }
    
    /**
    获取商铺分类列表以及分类下的商品列表
    
    :param: shopId     商铺编号
    :param: completion 如果请求正常，返回分类列表，否则返回错误
    */
    func fetchEntityProductList(shopId: String, completion: ([TMCategory]?, NSError?) -> Void) {
        
        // 首先判断本地数据库是否有数据
        // 如果有数据那么就从本地获取
        
        // 否则就从网络请求，并缓存本地
//        shopService.fetchEntityProductList(shopId, completion: completion)
        shopService.fetchEntityProductList(shopId, completion: { (list, error) -> Void in
            
            var managedContext = CoreDataStack.sharedInstance.context
            
            if error == nil {
                let categoryEntity = NSEntityDescription.entityForName("TMCategoryManagedObject",
                    inManagedObjectContext: managedContext)
                let productEntity = NSEntityDescription.entityForName("TMProductManagedObject",
                    inManagedObjectContext: managedContext)
                
                for var i = 0; i < list!.count; ++i {
                    var categoryRecord = list![i]
                    
                    let category = TMCategoryManagedObject(entity: categoryEntity!,
                        insertIntoManagedObjectContext: managedContext)
                    
                    // ---- 赋值 Category
                    category.category_id = categoryRecord.category_id!
                    category.category_name =  categoryRecord.category_name!
                    // ----
                    
                    var productList = categoryRecord.products!
                    var products = NSMutableSet()
                    for var m = 0; m < productList.count; ++m {
                        var productRecord = productList[m]
                        
                        let product = TMProductManagedObject(entity: productEntity!,
                            insertIntoManagedObjectContext: managedContext)
                    }
                    
                    var error: NSError?
                    if !managedContext.save(&error) {
                        println("Could not save: \(error)")
                    }
                    
                }
                
                //Save the managed object context
                
            }
            
            completion(list, error)
        })
        
    }
}
