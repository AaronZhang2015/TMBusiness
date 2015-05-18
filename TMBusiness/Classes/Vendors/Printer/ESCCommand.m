//
//  ESCCommand.m
//  TestSocketDemo
//
//  Created by ZhangMing on 5/14/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

#import "ESCCommand.h"

@implementation ESCCommand

- (instancetype)init
{
    if (self = [super init]) {
        _content = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)addCommand: (NSData *)cmd
{
    [_content appendData:cmd];
}

- (void)addText: (NSString *)content
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *contentData = [content dataUsingEncoding:enc];
    [_content appendData:contentData];
}

- (void)clearAll
{
    _content = [[NSMutableData alloc] init];
}

@end
