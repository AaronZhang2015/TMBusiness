//
//  PrinterCmdUtils.m
//  TestSocketDemo
//
//  Created by ZhangMing on 5/14/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

#import "PrinterCmdUtils.h"

@implementation PrinterCmdUtils

- (void)test {
    NSLog(@"%d", ESC);
}

- (NSData *)printerInit
{
    Byte result[] = {ESC, 64};
    
    return [NSData dataWithBytes:result length:2];
}

- (NSData *)nextLine:(NSInteger)lineNum
{
    Byte result[lineNum];
    
    for (int i = 0; i < lineNum; ++i) {
        result[i] = LF;
    }
    
    return [NSData dataWithBytes:result length:lineNum];
}

- (NSData *)underlineOn:(NSInteger)width
{
    Byte result[] = {ESC, 45, width};
    return [NSData dataWithBytes:result length:3];
}

- (NSData *)underlineOff
{
    Byte result[] = {ESC, 45, 0};
    return [NSData dataWithBytes:result length:3];
}

- (NSData *)boldOn
{
    Byte result[] = {ESC, 69, 0xF};
    return [NSData dataWithBytes:result length:3];
}

- (NSData *)boldOff
{
    Byte result[] = {ESC, 69, 0};
    return [NSData dataWithBytes:result length:3];
}

- (NSData *)align:(PrinterAlignment)alignment
{
    Byte result[] = {ESC, 97, alignment};
    return [NSData dataWithBytes:result length:3];
}

- (NSData *)setHTPosition:(NSInteger)col
{
    Byte result[] = {ESC, 68, col, 0};
    return [NSData dataWithBytes:result length:4];
}

- (NSData *)setFontSize:(NSInteger)num
{
    
    NSInteger realsize = 0;
    switch (num) {
        case 1:
            realsize = 0;
            break;
        case 2:
            realsize = 17;
            break;
        case 3:
            realsize = 34;
            break;
        case 4:
            realsize = 51;
            break;
        case 5:
            realsize = 68;
            break;
        case 6:
            realsize = 85;
            break;
        case 7:
            realsize = 102;
            break;
        case 8:
            realsize = 119;
            break;
        default:
            realsize = 0;
            break;
    }
    
    Byte result[] = {29, 33, realsize};
    return [NSData dataWithBytes:result length:3];
}

- (NSData *)setFontSizeWithWidth:(NSInteger)width height:(NSInteger)height underline: (BOOL)hasUnderLine
{
    NSInteger count = 0;
    if (width > 0) {
        count += 4;
    }
    
    if (height > 0) {
        count += 8;
    }
    
    if (hasUnderLine) {
        count += 128;
    }
    
    Byte result[] = {FS, 33, count};
    return [NSData dataWithBytes:result length:3];
}

- (NSData *)resetFontSize
{
    Byte result[] = {ESC, 33};
    return [NSData dataWithBytes:result length:2];
}

@end
