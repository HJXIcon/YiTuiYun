//
//  NSString+JXExtension.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/8/28.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "NSString+JXExtension.h"

@implementation NSString (JXExtension)
//用对象的方法计算文本的大小
- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size {
    
    //特殊的格式要求都写在属性字典中
    NSDictionary *attrs = @{NSFontAttributeName: font};
    //返回一个矩形，大小等于文本绘制完占据的宽和高。
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font andMaxSize:(CGSize)size{
    
    NSDictionary *attrs = @{NSFontAttributeName: font};
    
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


//用对象的方法计算文本的大小
- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size lineSpacing:(CGFloat)lineSpacing {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:lineSpacing];
    //特殊的格式要求都写在属性字典中
    NSDictionary *attrs = @{
                            NSFontAttributeName: font,
                            NSParagraphStyleAttributeName : style
                            };
    //返回一个矩形，大小等于文本绘制完占据的宽和高。
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


//获取时间戳 从1970年
- (NSString *)getTimestamp{
    NSDate *date = [NSDate date];
    NSTimeInterval times =  [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f",times];
}


/**
 时间戳 转 时间格式

 @param format 格式
 @return 时间
 */
- (NSString *)timeIntervalWithFormat:(NSString *)format{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

/**
 时间戳 计算年龄

 @return 年龄
 */
- (NSString *)timeIntervalToAge{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    
    NSTimeInterval dateDiff = [date timeIntervalSinceNow];
    
    long age = fabs(dateDiff/(60*60*24))/365;
    
    return [NSString stringWithFormat:@"%ld",age];
}
@end
