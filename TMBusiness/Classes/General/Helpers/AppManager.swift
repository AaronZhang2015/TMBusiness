//
//  AppManager.swift
//  ThinMeBussiness
//
//  Created by ZhangMing on 15/3/5.
//  Copyright (c) 2015年 ZhangMing. All rights reserved.
//

import UIKit

public enum Platform: Int {
    case iPhone = 0
    case iPad
    case Android
}

public class AppManager: NSObject {
    
    public class func platform() -> Platform {
        if UIDevice.currentDevice().respondsToSelector("userInterfaceIdiom") {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                return .iPad
            }
        }
        
        return .iPhone
    }

}
