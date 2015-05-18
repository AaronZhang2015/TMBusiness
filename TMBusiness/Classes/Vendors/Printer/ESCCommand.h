//
//  ESCCommand.h
//  TestSocketDemo
//
//  Created by ZhangMing on 5/14/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESCCommand : NSObject

@property (strong, nonatomic) NSMutableData *content;

- (void)addCommand: (NSData *)cmd;

- (void)addText: (NSString *)content;

- (void)clearAll;

@end
