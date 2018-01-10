//
//  NSString+QJAddition.m
//  QJIPHONE
//
//  Created by xiaoyu-ys on 14-3-13.
//  Copyright (c) 2014年 Messi. All rights reserved.
//

#import "NSString+QJAddition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Addition)
+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
#pragma mark
#pragma mark NSString  MD5
- (NSString *)stringFromMD5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (unsigned int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}
#pragma mark
#pragma mark  NSString isEmpty
+ (BOOL)stringIsEmpty:(NSString *)str
{
    if (![str isKindOfClass:[NSString class]]) {
        str = [str description];
        return YES;
    }
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([str length] == 0) {
        return YES;
    }

    return NO;
}

#pragma mark
#pragma mark NSString isBlank
+ (BOOL)stringIsBlank:(NSString *)str
{
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark
#pragma mark 获取当前日期，时间
+(NSDate *)getCurrentDate{
    NSDate *now = [NSDate date];
    return now;
}
#pragma mark
#pragma mark 将日期转换为字符串（日期，时间） yyyy-MM-dd
+(NSString *)getDateStringFromDate:(NSDate *)date{
    NSInteger location = 0;
    NSString *timeStr = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"HH:mm:a"];
    NSString *ampm = [[[formatter stringFromDate:date] componentsSeparatedByString:@":"] objectAtIndex:2];
    timeStr = [formatter stringFromDate:date];
    NSRange range = [timeStr rangeOfString:[NSString stringWithFormat:@":%@",ampm]];
    location = range.location;
    NSString *string = [timeStr substringToIndex:location];
    timeStr = [NSString stringWithFormat:@"%@ %@",ampm,string];
    
    
    NSString *dateStr = @"";
    NSDateFormatter *Dformatter = [[NSDateFormatter alloc] init];
    [Dformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [Dformatter setDateFormat:@"yyyy-MM-dd"];
    dateStr = [Dformatter stringFromDate:date];
    return dateStr;
}
#pragma mark
#pragma mark 将日期转换为字符串（日期，时间） yyyy/MM/dd
+(NSString *)getDateStringFromDateToBias:(NSDate *)date{
    NSInteger location = 0;
    NSString *timeStr = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"HH:mm:a"];
    NSString *ampm = [[[formatter stringFromDate:date] componentsSeparatedByString:@":"] objectAtIndex:2];
    timeStr = [formatter stringFromDate:date];
    NSRange range = [timeStr rangeOfString:[NSString stringWithFormat:@":%@",ampm]];
    location = range.location;
    NSString *string = [timeStr substringToIndex:location];
    timeStr = [NSString stringWithFormat:@"%@ %@",ampm,string];
    
    
    NSString *dateStr = @"";
    NSDateFormatter *Dformatter = [[NSDateFormatter alloc] init];
    [Dformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [Dformatter setDateFormat:@"yyyy/MM/dd"];
    dateStr = [Dformatter stringFromDate:date];
    return dateStr;
}
@end
