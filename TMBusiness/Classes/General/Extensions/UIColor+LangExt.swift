//
//  UIColor+LangExt.swift
//  AZLockView
//
//  Created by ZhangMing on 15/1/6.
//  Copyright (c) 2015年 ZhangMing. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hex: Int) {
        var red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        var green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        var blue = CGFloat(hex & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    convenience init(hex: Int, alpha: Double) {
        var red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        var green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        var blue = CGFloat(hex & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}
