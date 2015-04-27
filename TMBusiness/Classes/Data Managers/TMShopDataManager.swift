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
    
    lazy var cacheService: TMCacheService = {
        return TMCacheService()
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
        var categories = fetchCategoryAndProductFromCache()
        
        if categories.count > 0 {
            completion(categories, nil)
        } else {
            // 否则就从网络请求，并缓存本地
            shopService.fetchEntityProductList(shopId, completion: { (list, error) -> Void in
                
                // 缓存数据
                if error == nil {
                    self.cacheCategoryAndProduct(list!)
                    var result = self.fetchCategoryAndProductFromCache()
                    completion(result, nil)
                } else {
                    completion(list, error)
                }
            })
        }
    }
    
    /**
    缓存商品分类以及商品数据
    
    :param: list 商品分类
    */
    func cacheCategoryAndProduct(list: [TMCategory]) {
        
        clearCategoryAndProduct()
        
        var managedContext = CoreDataStack.sharedInstance.context
        
        let categoryEntity = NSEntityDescription.entityForName("TMCategoryManagedObject",
            inManagedObjectContext: managedContext)
        let productEntity = NSEntityDescription.entityForName("TMProductManagedObject",
            inManagedObjectContext: managedContext)
        
        for var i = 0; i < list.count; ++i {
            var categoryRecord = list[i]
            
            let category = TMCategoryManagedObject(entity: categoryEntity!,
                insertIntoManagedObjectContext: managedContext)
            
            // ---- 赋值 Category
            category.category_id = categoryRecord.category_id!
            category.category_name =  categoryRecord.category_name!
            category.category_pid = categoryRecord.category_pid!
            category.is_discount = categoryRecord.is_discount!
            category.discount_type = categoryRecord.discount_type!
            // ----
            
            // ---- 赋值 Product
            var productList = categoryRecord.products!
            var products = NSMutableOrderedSet()//NSMutableSet()
            for var m = 0; m < productList.count; ++m {
                var productRecord = productList[m]
                
                let product = TMProductManagedObject(entity: productEntity!,
                    insertIntoManagedObjectContext: managedContext)
                
                product.product_id = productRecord.product_id!
                product.product_name = productRecord.product_name!
                product.product_description = productRecord.product_description!
                product.title_1 = productRecord.title_1!
                product.title_2 = productRecord.title_2!
                product.title_3 = productRecord.title_3!
                product.title_4 = productRecord.title_4!
                product.title_5 = productRecord.title_5!
                product.description_1 = productRecord.description_1!
                product.description_2 = productRecord.description_2!
                product.description_3 = productRecord.description_3!
                product.description_4 = productRecord.description_4!
                product.description_5 = productRecord.description_5!
                product.image_url = productRecord.image_url!
                product.official_quotation = productRecord.official_quotation
                product.monetary_unit = productRecord.monetary_unit!
                product.width = productRecord.width!
                product.height = productRecord.height!
                product.category_id = productRecord.category_id!
                product.category_name = productRecord.category_name!
                product.is_discount = productRecord.is_discount!
                product.discount_type = productRecord.discount_type!
                product.aTemplate_examples_plate = productRecord.aTemplate_examples_plate!
                products.addObject(product)
            }
            
            category.products = products
        }
        
        //Save the managed object context
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
        }
    }
    
    /**
    清楚缓存商品分类数据
    */
    func clearCategoryAndProduct() {
        var managedContext = CoreDataStack.sharedInstance.context
        let categoryFetch = NSFetchRequest(entityName: "TMCategoryManagedObject")
        var error: NSError?
        let result = managedContext.executeFetchRequest(categoryFetch, error: &error) as! [TMCategoryManagedObject]
        for category in result {
            managedContext.deleteObject(category)
            
            for product in category.products {
                managedContext.deleteObject(product as! TMProductManagedObject)
            }
        }
        
        //Save the managed object context
        if !managedContext.save(&error) {
            println("Could not save: \(error)")
        }
    }
    
    
    /**
    从缓存中加载商品分类
    
    :returns: 商品分类
    */
    func fetchCategoryAndProductFromCache() -> [TMCategory] {
        var categoryList = [TMCategory]()
        
        var managedContext = CoreDataStack.sharedInstance.context
        let categoryFetch = NSFetchRequest(entityName: "TMCategoryManagedObject")
        
        var nameDescriptor = NSSortDescriptor(key: "category_name", ascending: false)
        categoryFetch.sortDescriptors = [nameDescriptor]
        
        var error: NSError?
        let result = managedContext.executeFetchRequest(categoryFetch, error: &error) as! [TMCategoryManagedObject]
        
        for var i = 0; i < result.count; i++ {
            var categoryRecord = result[i]
            var category = TMCategory()
            
            // ---- 赋值 Category
            category.category_id = categoryRecord.category_id
            category.category_name =  categoryRecord.category_name
            category.category_pid = categoryRecord.category_pid
            category.is_discount = categoryRecord.is_discount
            category.discount_type = categoryRecord.discount_type
            // ----
            
            // ---- 赋值 Product
            var productList = categoryRecord.products.array as! [TMProductManagedObject]
            
            var products = [TMProduct]()
            for var m = 0; m < productList.count; ++m {
                var productRecord = productList[m]
                var product = TMProduct()
                product.product_id = productRecord.product_id
                product.product_name = productRecord.product_name
                product.product_description = productRecord.product_description
                product.title_1 = productRecord.title_1
                product.title_2 = productRecord.title_2
                product.title_3 = productRecord.title_3
                product.title_4 = productRecord.title_4
                product.title_5 = productRecord.title_5
                product.description_1 = productRecord.description_1
                product.description_2 = productRecord.description_2
                product.description_3 = productRecord.description_3
                product.description_4 = productRecord.description_4
                product.description_5 = productRecord.description_5
                product.image_url = productRecord.image_url
                product.official_quotation = productRecord.official_quotation
                product.monetary_unit = productRecord.monetary_unit
                product.width = productRecord.width
                product.height = productRecord.height
                product.category_id = productRecord.category_id
                product.category_name = productRecord.category_name
                product.is_discount = productRecord.is_discount
                product.discount_type = productRecord.discount_type
                product.aTemplate_examples_plate = productRecord.aTemplate_examples_plate
                
                products.append(product)
            }
            
            category.products = products
            categoryList.append(category)
        }
        
        return categoryList
    }
    
    
    func fetchStatisticsDetail(businessId: String, shopId: String, startDate: NSDate, endDate: NSDate, adminId: String, extensionField: String = "", completion: (TMCheckingAccount?, NSError?) -> Void) {
        var startDateTimeInterval: NSTimeInterval = startDate.timeIntervalSince1970
        var endDateTimeInterval: NSTimeInterval = endDate.timeIntervalSince1970
        
        shopService.fetchStatisticsDetail(businessId, shopId: shopId, startDate: "\(Int(startDateTimeInterval))", endDate: "\(Int(endDateTimeInterval))", adminId: adminId, extensionField: extensionField, completion: completion)
    }
}
