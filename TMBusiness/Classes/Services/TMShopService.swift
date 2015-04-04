//
//  TMShopService.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 3/30/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit
import Alamofire

class TMShopService: NSObject {
    lazy var manager: TMNetworkManager = {
        return TMNetworkManager()
        }()
    
    /**
    商户用户登录
    
    :param: username   用户名
    :param: password   密码
    :param: completion 如果正确请求，返回商铺信息，否则返回错误
    */
    func login(username: String , password: String, completion: (TMShop?, NSError?) -> Void) {
        manager.request(.POST, relativePath: "shop_login", parameters: ["login_account": username, "login_password": password, "device_type": AppManager.platform().rawValue]) { (result) -> Void in
            switch result {
            case let .Error(e):
                completion(nil, e)
            case let .Value(json):
                // 解析数据
                let data = json["data"]
                
                var shop = TMShop.sharedInstance
                shop.shop_id = data["shop_id"].stringValue
                shop.shop_name = data["shop_name"].stringValue
                shop.admin_id = data["admin_id"].stringValue
                shop.address = data["address"].string
                shop.business_id = data["business_id"].stringValue
                
                completion(shop, nil)
            }
        }
    }
    
    /**
    根据商铺编号获取商品列表（包含分类及打折信息）
    
    :param: shopId     商铺编号
    :param: completion 如果正确请求，返回分类列表，否则返回错误
    */
    func fetchEntityProductList(shopId: String, completion: ([TMCategory]?, NSError?) -> Void) {
        manager.request(.POST, relativePath: "shop_getEntityProductListPlus", parameters: ["shop_id": shopId, "category_id": "", "device_type": AppManager.platform().rawValue, "user_id": "", "extension_field": "", "page_index": "", "page_size": ""]) { (result) -> Void in
            switch result {
            case let .Error(e):
                completion(nil, e)
            case let .Value(json):
                // 解析数据
                let data = json["data"]
                
                println(data)
                // 分类列表
                var models = [TMCategory]()
                
                for var index = 0; index < data.count; ++index {
                    var model = TMCategory()
                    var result = data[index]
                    
                    model.category_id = result["category_id"].string
                    model.category_pid = result["category_pid"].string
                    model.category_name = result["category_name"].string
                    model.is_discount = result["is_discount"].number
                    model.discount_type = result["discount_type"].string
                    
                    
                    // 解析分类下的商品
                    var products = [TMProduct]()
                    var productList = result["products"]
                    
                    for var productIndex = 0; productIndex < productList.count; ++productIndex {
                        var product = TMProduct()
                        var productResult = productList[productIndex]
                        product.product_id = productResult["product_id"].string
                        product.product_name = productResult["product_name"].string
                        product.product_description = productResult["product_description"].string
                        product.title_1 = productResult["title_1"].string
                        product.description_1 = productResult["description_1"].string
                        product.title_2 = productResult["title_2"].string
                        product.description_2 = productResult["description_2"].string
                        product.title_3 = productResult["title_3"].string
                        product.description_3 = productResult["description_3"].string
                        product.title_4 = productResult["title_4"].string
                        product.description_4 = productResult["description_4"].string
                        product.title_5 = productResult["title_5"].string
                        product.description_5 = productResult["description_5"].string
                        product.image_url = productResult["image_url"].string
                        product.official_quotation = productResult["official_quotation"].numberValue
                        product.monetary_unit = productResult["monetary_unit"].string
                        product.width = productResult["width"].number
                        product.height = productResult["height"].number
                        product.category_id = productResult["category_id"].string
                        product.category_name = productResult["category_name"].string
                        product.is_discount = productResult["is_discount"].number
                        product.discount_type = productResult["discount_type"].string
                        product.aTemplate_examples_plate = productResult["aTemplate_examples_plate"].string
                        
                        products.append(product)
                    }
                    
                    model.products = products
                    
                    models.append(model)
                }
                
                completion(models, nil)
            }
        }
    }
}
