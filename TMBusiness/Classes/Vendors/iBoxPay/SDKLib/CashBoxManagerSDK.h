//
//  CashBoxManagerSDK.h
//  CashBoxSDK
//
//  Created by 朱克锋 on 13-3-1.
//  Copyright (c) 2013年 深圳盒子支付信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CashBoxManagerSDKDelegate <NSObject>
@optional
//刷卡状态
-(void)brushCardState:(BOOL)state withMsg:(NSString*)msg;
//实名认证状态
-(void)DPIState:(BOOL)state withMsg:(NSString*)msg;

//三次密码错误验证图
-(void)loginErrorWithInfo:(NSData*)imgData;
//支付结果
-(void)payResultWithInfo:(NSDictionary*)info;
//支付错误结果
-(void)payErrorWithInfo:(NSError*)error;

@end

@interface CashBoxManagerSDK : NSObject
{
    id<CashBoxManagerSDKDelegate> delegate;
}
@property (nonatomic, assign) id<CashBoxManagerSDKDelegate> delegate;

+ (CashBoxManagerSDK *)shardCashBoxManagerSDK;
@end
