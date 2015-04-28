//
//  AZNumberTool.swift
//  TMBusiness
//
//  Created by ZhangMing on 4/9/15.
//  Copyright (c) 2015 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

let AZMaxAmountNumberLength = 12

extension String {
   
    /**
    处理输入金额的格式
    
    :param: text 期望输入的内容
    
    :returns: 处理后的结果
    */
    func hanldeAmountNumberFormat(text: String) -> String {
        if count(self) > 12 {
            return self
        }
        
        // 小数点判定
        if text == "." {
            // 如果text已经包含小数点，则不进行处理
            if let range = rangeOfString(".") {
                return self
            } else {
                // 如果第一个字符是".",那么添加一个0
                if count(self) == 0 {
                    return "0"
                }
            }
            
            // 如果不包含小数点，则添加进去
            return "\(self)."
        } else {
            // 小数点后面可以输入几位
            var range = (self as NSString).rangeOfString(".")
            if range.location != NSNotFound{
                var length = count(self)
                if (length - range.location - 1) >= 2 {
                    return self
                }
            }
            // 如果首位是"0"，而第二位不是小数点".", 那么删除"0"字符
            if count(self) == 1 {
                if (self as NSString).substringToIndex(1) == "0" {
                    return "\((self as NSString).substringFromIndex(1))\(text)"
                }
                
            }
            return "\(self)\(text)"
        }
    }
    
    var doubleValue: Double {
        if let number = NSNumberFormatter().numberFromString(self) {
            return number.doubleValue
        }
        
        return 0
    }
    
    var toNumber: NSNumber? {
        if let number = NSNumberFormatter().numberFromString(self) {
            return number
        }
        
        return nil
    }
    
//    var twoPositionDoubleValue: Double {
//        var numberFormatter = NSNumberFormatter()
//        numberFormatter.positiveFormat = "0.00"
//        if let number = numberFormatter.numberFromString(self) {
////            numberFormatter.
//            numberFormatter.strin
//        }
//    }
    
    static func generateString(number: Int) -> String {
        var temp = ""
        for var index = 0; index < number; ++index {
            var randomNumber = arc4random() % 75 + 48
            var character = Character(UnicodeScalar(randomNumber))
            temp = "\(temp)\(character)"
        }
        
        return temp
    }
}
