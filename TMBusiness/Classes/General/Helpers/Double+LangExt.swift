//
//  Double+LangExt.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/9/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import Foundation

extension Double {
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}