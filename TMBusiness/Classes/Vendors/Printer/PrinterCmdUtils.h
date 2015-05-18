//
//  PrinterCmdUtils.h
//  TestSocketDemo
//
//  Created by ZhangMing on 5/14/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ESC = 27,           // 换码
    FS  = 28,           // 文本分隔符
    GS  = 29,           // 组分隔符
    DLE = 16,           // 数据连接换码
    EOT = 4,            // 传输结束
    ENQ = 5,            // 询问字符
    SP  = 32,           // 空格
    HT  = 9,            // 横向列表
    LF  = 10,           // 打印并换行（水平定位）
    CR  = 13,           // 归位键
    FF  = 12,           // 走纸控制（打印并回到标准模式（在页模式下））
    CAN = 24            // 作废（页模式下取消打印数据 ）
    
} PrinterCommand;

typedef enum {
    PrinterAlignmentLeft = 0,
    PrinterAlignmentCenter= 1,
    PrinterAlignmentRight = 2,
} PrinterAlignment;


@interface PrinterCmdUtils : NSObject

- (void)test;

/**
 *  打印机初始化指令
 *
 *  @return 指令
 */
- (NSData *)printerInit;

/**
 *  换行
 *
 *  @param lineNum 几行
 *
 *  @return 指令
 */
- (NSData *)nextLine:(NSInteger)lineNum;


/**
 *  绘制下划线
 *
 *  @param width 宽度
 *
 *  @return 指令
 */
- (NSData *)underlineOn:(NSInteger)width;


/**
 *  取消绘制下划线
 *
 *  @return 指令
 */
- (NSData *)underlineOff;


/**
 *  选择加粗模式
 *
 *  @return 指令
 */
- (NSData *)boldOn;

/**
 *  取消加粗模式
 *
 *  @return 指令
 */
- (NSData *)boldOff;

/**
 *  设置对齐方式
 *
 *  @param alignment 0：左，1：居中，2右
 *
 *  @return 指令
 */
- (NSData *)align:(PrinterAlignment)alignment;


/**
 *  水平方向右移多少列
 *
 *  @param col 列数
 *
 *  @return 指令
 */
- (NSData *)setHTPosition:(NSInteger)col;


/**
 *  字体变大为标准的几倍
 *
 *  @param num 倍数
 *
 *  @return 指令
 */
- (NSData *)setFontSize:(NSInteger)num;


/**
 *  设置字符格式
 *
 *  @param width        倍宽
 *  @param height       高宽
 *  @param hasUnderLine 是否有下划线
 *
 *  @return 指令
 */
- (NSData *)setFontSizeWithWidth:(NSInteger)width height:(NSInteger)height underline: (BOOL)hasUnderLine;


/**
 *  字体恢复原来状态
 *
 *  @return 指令
 */
- (NSData *)resetFontSize;
@end
