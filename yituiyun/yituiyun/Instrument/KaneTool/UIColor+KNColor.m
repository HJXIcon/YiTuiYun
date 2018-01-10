//
//  UIColor+KNColor.m
//  妈咪宝贝
//
//  Created by LUKHA_Lu on 15/6/20.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import "UIColor+KNColor.h"

@implementation UIColor (KNColor)

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue{
    UIColor *color = [self colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
    return color;
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha{
    UIColor *color = [self colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
    return color;
}

@end
