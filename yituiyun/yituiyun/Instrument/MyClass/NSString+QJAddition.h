//
//  NSString+QJAddition.h
//  QJIPHONE
//
//  Created by xiaoyu-ys on 14-3-13.
//  Copyright (c) 2014年 Messi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

+(NSString *) md5: (NSString *) inPutText;
//NSString  MD5
- (NSString *)stringFromMD5;
//NSString isEmpty
+ (BOOL)stringIsEmpty:(NSString *)str;
//NSString is Blank
+ (BOOL)stringIsBlank:(NSString *)str;
//获取当前日期，时间
+ (NSDate *)getCurrentDate;
//将日期转换为字符串（日期，时间）yyyy-MM-dd
+ (NSString *)getDateStringFromDate:(NSDate *)date;
//将日期转换为字符串（日期，时间） yyyy/MM/dd
+ (NSString *)getDateStringFromDateToBias:(NSDate *)date;
@end
