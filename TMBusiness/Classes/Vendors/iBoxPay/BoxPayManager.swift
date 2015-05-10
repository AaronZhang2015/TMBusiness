//
//  BoxPayManager.swift
//  TMBusiness
//
//  Created by ZhangMing on 15/5/10.
//  Copyright (c) 2015年 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit
import CryptoSwift

class BoxPayManager: NSObject {
    lazy var loginViewController = CBLoginViewController()
    
    override init() {
        super.init()
        CashBoxManagerSDK.shardCashBoxManagerSDK().delegate = self
    }
    
    func pay() {
        var signMessage: String = ""
        var signDict = NSMutableDictionary()
        
        loginViewController.setIsDefualtConnectTypeForBT(true)
        loginViewController.delegate = self
        
        // 加载支付信息
        //---------登录参数---------------------------------
        loginViewController.datas.username = "15195988772#02"
        
        //必须用MD5加密后的密文,并且转换为大写
        loginViewController.datas.password = "123456".md5()!.uppercaseString
        // 商户名称
        loginViewController.datas.outMchName = "ThingMe"
        // 商户合作ID,由盒子支付分配
        loginViewController.datas.partner = "10332010089990134"
        signDict.setValue(loginViewController.datas.partner, forKey: "partner")
        
        // 第三方的公司交易订单号
        loginViewController.datas.outTradeNo = "12121212121212"
        signDict.setValue(loginViewController.datas.outTradeNo, forKey: "outTradeNo")
        
        // 交易金额
        loginViewController.datas.totalFee = 200 //精确到分
        signDict.setValue(NSNumber(longLong: loginViewController.datas.totalFee), forKey: "totalFee")
        
        // 编码方式
        loginViewController.datas._inputCharset = "UTF-8"
        signDict.setValue(loginViewController.datas._inputCharset, forKey: "_inputCharset")
        
        // 服务器回调的地址
        loginViewController.datas.notifyUrl = "http://172.30.10.22:8080/iboxpay"
        signDict.setValue(loginViewController.datas.notifyUrl, forKey: "notifyUrl")
        
        // 加密方式（加密必须需要盒子支付公司配置登录账号的公钥key,否则交易不成功，提示公钥不匹配；这个可以找项目负责人处理）
        loginViewController.datas.signType = "MD5"
        
        var returnSortStr = ""
        var keyArray = signDict.allKeys as NSArray
        keyArray = keyArray.sortedArrayUsingSelector("compare:")
        for var i = 0; i < keyArray.count; ++i {
            if (count(returnSortStr) == 0) {
                var key = keyArray[i] as! String
                var tempStr = "\(key)=\(signDict[key]))"
                returnSortStr = "\(returnSortStr)\(tempStr)"
            } else {
                var key = keyArray[i] as! String
                var tempStr = "&\(key)=\(signDict[key]))"
                returnSortStr = "\(returnSortStr)\(tempStr)"
            }
        }
        
        signMessage = returnSortStr
        signMessage = signMessage.stringByAppendingString("&key=f218542278ff4e85b7ce00ed390c4ba7")
        signMessage.md5()
        
        loginViewController.datas.signContent = signMessage
    }
}

extension BoxPayManager: CBLoginViewControllerDelegate {
    func authError() {
        
    }
}

extension BoxPayManager: CashBoxManagerSDKDelegate {
    func payErrorWithInfo(error: NSError!) {
        
    }
    
    func payResultWithInfo(info: [NSObject : AnyObject]!) {
        
    }
    
    func loginErrorWithInfo(imgData: NSData!) {
        
    }
}