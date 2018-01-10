//
//  NSString+JXExtension.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/8/28.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (JXExtension)

/// 计算文本的大小
+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font andMaxSize:(CGSize)size;

- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size;

/**
 计算文本的大小

 @param font 字体
 @param size size
 @param lineSpacing 行间距
 */
- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size lineSpacing:(CGFloat)lineSpacing;

#pragma mark - *** 时间相关
/**
 获取时间戳 从1970年
 
 */
- (NSString *)getTimestamp;

/**
 时间戳 转 时间格式
 
 @param format 格式
 @return 时间
 */
- (NSString *)timeIntervalWithFormat:(NSString *)format;

/**
 时间戳 计算年龄
 
 @return 年龄
 */
- (NSString *)timeIntervalToAge;

@end
