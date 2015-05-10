//
//  Datas.h
//  CashBoxSDK
//
//  Created by 朱克锋 on 13-2-28.
//  Copyright (c) 2013年 深圳盒子支付信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantDatas : NSObject

//----------------基础参数---------------------------
// 用户账号
@property(retain ,nonatomic) NSString *username;
// 用户密码
@property(retain ,nonatomic) NSString *password;
// 第三方公司合作ID号
@property(retain ,nonatomic) NSString *partner;
// 商户名称
@property(retain ,nonatomic) NSString *outMchName;
// 参数编码字符集
@property(retain ,nonatomic) NSString *_inputCharset;
// 签名方式
@property(retain ,nonatomic) NSString *signType;
// 签名内容
@property(retain ,nonatomic) NSString *signContent;
// 服务器异步通知页面路径（可空）
@property(retain ,nonatomic) NSString *notifyUrl;
//----------------基础参数---------------------------

//----------------业务参数---------------------------
// 商户统一订单号
@property(retain ,nonatomic) NSString *outTradeNo;
// 支付总金额（以分为单位）
@property(assign ,nonatomic) long long totalFee;
//// 公用业务扩展信息（可空）
//@property(retain ,nonatomic) NSString *extend_params;
//----------------业务参数---------------------------
@end
