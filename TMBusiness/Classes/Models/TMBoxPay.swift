//
//  TMBoxPay.swift
//  TMBusiness
//
//  Created by ZhangMing on 15/5/10.
//  Copyright (c) 2015年 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

let boxPath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last as! String).stringByAppendingPathComponent("boxPay")

class TMBoxPay: NSObject, NSCoding {
    
    // 盒子支付SN号
    var sn: String!
    
    // 盒子支付账户
    var account: String!
    
    // 盒子支付密码
    var password: String!
    
    // 合作者编号
    var partner: String! = "10332010089990134"
    
    // md5 key
    var md5Key: String! = "f218542278ff4e85b7ce00ed390c4ba7"
    
    override init() {
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(Crypto.DesEncrypt(sn, keyStr: "Xunmimi$"), forKey: "sn")
        aCoder.encodeObject(Crypto.DesEncrypt(account, keyStr: "Xunmimi$"), forKey: "account")
        aCoder.encodeObject(Crypto.DesEncrypt(password, keyStr: "Xunmimi$"), forKey: "password")
        aCoder.encodeObject(Crypto.DesEncrypt(partner, keyStr: "Xunmimi$"), forKey: "partner")
        aCoder.encodeObject(Crypto.DesEncrypt(md5Key, keyStr: "Xunmimi$"), forKey: "md5Key")
    }
    
    required init(coder aDecoder: NSCoder) {
        sn = Crypto.DesDecrypt((aDecoder.decodeObjectForKey("sn") as! String), keyStr: "Xunmimi$")
        account = Crypto.DesDecrypt((aDecoder.decodeObjectForKey("account") as! String), keyStr: "Xunmimi$")
        password = Crypto.DesDecrypt((aDecoder.decodeObjectForKey("password") as! String), keyStr: "Xunmimi$")
        partner = Crypto.DesDecrypt((aDecoder.decodeObjectForKey("partner") as! String), keyStr: "Xunmimi$")
        md5Key = Crypto.DesDecrypt((aDecoder.decodeObjectForKey("md5Key") as! String), keyStr: "Xunmimi$")
    }
}
