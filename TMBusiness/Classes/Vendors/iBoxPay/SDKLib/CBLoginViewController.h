//
//  CBLoginViewController.h
//  CashBoxSDK
//
//  Created by 朱克锋 on 13-2-22.
//  Copyright (c) 2013年 深圳盒子支付信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MerchantDatas.h"
@protocol CBLoginViewControllerDelegate <NSObject>
@optional
-(void)authError;
-(void)authSuc;
@end

@interface CBLoginViewController : UIViewController

@property (nonatomic, assign) id<CBLoginViewControllerDelegate> delegate;
@property (retain ,nonatomic) MerchantDatas *datas;

-(void)setIsDefualtConnectTypeForBT:(BOOL)isBT;
-(BOOL)getIsDefualtConnectTypeForBT;

-(void)setIDefualtSendOrder:(BOOL)isSend;
-(BOOL)getIDefualtSendOrder;

@end

