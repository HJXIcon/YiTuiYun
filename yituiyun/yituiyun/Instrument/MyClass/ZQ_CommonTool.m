//
//  CommonTool.m
//  商派
//
//  Created by NIT on 15-3-11.
//  Copyright (c) 2015年 NIT. All rights reserved.
//

#import "ZQ_CommonTool.h"
#import <objc/runtime.h>

@implementation ZQ_CommonTool
+ (BOOL)isValidateWithPredicate:(NSString *)predicateString valueString:(NSString *)valueString warningMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate alertKey:(NSString *)alertKey
{
    BOOL isValidate = [ZQ_CommonTool isValidate:predicateString valueString:valueString];
    if (!isValidate) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //set the property of alert view
        objc_setAssociatedObject(delegate, (__bridge void *)alertKey, alert, OBJC_ASSOCIATION_RETAIN);
        [alert show];
    }
    return isValidate;
}
+ (BOOL)isValidate:(NSString *)predicateString valueString:(NSString *)valueString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predicateString];
    BOOL isValidate = [predicate evaluateWithObject:valueString];
    
    return isValidate;
}

+ (BOOL)isEmpty:(NSString *)str
{
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (str == nil || str == NULL || [str isEqual:@"(null)"] || [str isEqual:@"<null>"] || [str isEqualToString:@""]) {
        return YES;
    }
    
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isEmptyArray:(NSArray *)array{
    if(array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0){
        return YES;
    }
    return NO;
}

+ (BOOL)isEmptyDictionary:(NSDictionary *)dictionary{
    if(dictionary == nil || [dictionary isKindOfClass:[NSNull class]] || dictionary.count == 0){
        return YES;
    }
    return NO;
}

+ (void)setObject:(id)obj key:(id)key dict:(NSMutableDictionary *)dict{
    if(obj)
        [dict setObject:obj forKey:key];
    else
        [dict removeObjectForKey:key];
}

+ (UILabel *)formatLabelWithFont:(UIFont *)aFont textString:(NSString *)aStr textColor:(UIColor *)aColor
{
    UILabel *formatLable = [[UILabel alloc] init];
    [formatLable setBackgroundColor:[UIColor clearColor]];
    [formatLable setFont:aFont];
    [formatLable setTextColor:aColor];
    [formatLable setText:aStr];
    [formatLable sizeToFit];
    
    return formatLable;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSString *)sortByKeyMD5:(NSDictionary *)dictionary
{
    return @"";
}

@end
