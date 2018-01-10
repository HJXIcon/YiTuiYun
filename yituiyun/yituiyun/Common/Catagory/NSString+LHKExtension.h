//
//  NSString+LHKExtension.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/10.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LHKExtension)
+ (BOOL)valiMobile:(NSString *)mobile;
+(NSString *)imagePathAddPrefix:(NSString *)str;
+(NSString *)returnFiledString:(NSInteger)index;

-(NSString *)stringIsNull;
+(NSString*)returnTaskType:(NSInteger)type;
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
+(NSString *)moneyType:(NSInteger)type;
+(BOOL)judgeIdentityStringValid:(NSString *)identityString;
+(NSString *)getStringWithCompanyType:(NSInteger)type;

+(NSString *)timeHasSecondTimeIntervalString:(NSString *)timeString;
/**
 时间戳 -->> YYYY-MM-dd hh:mm
 
 @param timeString 时间戳
 */
+(NSString *)timeHasMinuteTimeIntervalString:(NSString *)timeString;

+(NSString*)noticeNameWithType:(NSInteger)type;

+ (BOOL)isNeedToUpdateServerVersion:(NSString *)serverVersion andappVersion: (NSString *)appVersion;

+(NSString *)realNameStaus:(NSInteger)index;
+(NSString*)JianZhiStatusWithType:(NSInteger)type;
+(NSString *)unitJianZhiWithType:(NSInteger)type;
+(NSString *)settmenJianZhiWithType:(NSInteger)type;
+(NSString *)statusWithShenHe:(NSInteger)type;
+(NSString *)educationWithSheHe:(NSInteger)type;
+(NSString *)sexWithSheHe:(NSInteger)type;
+(NSString *)baomingStausWith:(NSInteger)type;
+(NSString *)jobTypeWithType:(NSInteger)type;


+(BOOL)isSuccesspriceNumber:(NSString *)string;

+(long long)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;
@end
