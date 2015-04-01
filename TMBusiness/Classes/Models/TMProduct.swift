//
//  TMProduct.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 3/30/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit


/**
*  产品实体模型
*/
class TMProduct: NSObject {
    // 产品编号
    var product_id: String?
    
    // 产品名称
    var product_name: String?

    // 产品描述
    var product_description: String?
    
    // 标题一
    var title_1: String?
    
    // 描述一（景点模板中存放音频地址）
    var description_1: String?
    
    // 标题二（景点模板中存放板块标题）
    var title_2: String?
    
    // 描述二
    var description_2: String?
    
    // 标题三
    var title_3: String?
    
    // 描述三
    var description_3: String?
    
    // 标题四
    var title_4: String?
    
    // 描述四
    var description_4: String?
    
    // 标题五
    var title_5: String?
    
    // 描述五
    var description_5: String?
    
    // 封面图片
    var image_url: String?
    
    // 官方报价
    var official_quotation: NSNumber?
    
    // 货币单位
    var monetary_unit: String?
    
    // 封面图片宽度
    var width: NSNumber?
    
    // 封面图片高度
    var height: NSNumber?
    
    // 商品分类编号
    var category_id: String?
    
    // 商品分类名称
    var category_name: String?
    
    // 是否参与打折（0：不参与任何打折类型  1：参与全部打折类型  2：参与部分打折类型）
    var is_discount: NSNumber?
    
    // 折扣/打折类型
    var discount_type: String?
    
    // 相关故事
    var aTemplate_examples_plate: String?
}



/*
product_id									产品编号
product_name									产品名称
product_description							产品描述
title_1										标题一
description_1									描述一（景点模板中存放音频地址）
title_2										标题二（景点模板中存放板块标题）
description_2									描述二
title_3										标题三
description_3									描述三
title_4										标题四
description_4									描述四
title_5										标题五
description_5									描述五
image_url									封面图片
official_quotation								官方报价
monetary_unit								货币单位
width										封面图片宽度
height										封面图片高度
category_id									商品分类编号
category_name								商品分类名称
is_discount									单品是否参与打折（0：不参与任何打折													类型  1：参与全部打折类型  2：参与部												分打折类型  3：继承该件商品分类打折													设置）
discount_type									折扣/打折类型
aTemplate_examples_plate						相关故事
*/