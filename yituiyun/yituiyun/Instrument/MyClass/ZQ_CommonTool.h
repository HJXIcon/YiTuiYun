//
//  CommonTool.h
//  商派
//
//  Created by NIT on 15-3-11.
//  Copyright (c) 2015年 NIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZQ_CommonTool : NSObject

/** check is validate with string */
+ (BOOL)isValidate:(NSString *)predicateString valueString:(NSString *)valueString;
/** check is validate predicate value delegate */
+ (BOOL)isValidateWithPredicate:(NSString *)predicateString valueString:(NSString *)valueString warningMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate alertKey:(NSString *)alertKey;
/** check the str is empty or not */
+ (BOOL)isEmpty:(NSString *)str;

+ (BOOL)isEmptyArray:(NSArray *)array;

+ (BOOL)isEmptyDictionary:(NSDictionary *)dictionary;

+ (void)setObject:(id)obj key:(id)key dict:(NSMutableDictionary *)dict;

+ (UILabel *)formatLabelWithFont:(UIFont *)aFont textString:(NSString *)aStr textColor:(UIColor *)aColor;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (NSString *)sortByKeyMD5:(NSDictionary *)dictionary;

@end
