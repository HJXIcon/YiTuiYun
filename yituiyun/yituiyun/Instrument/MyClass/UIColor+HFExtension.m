//
//  UIColor+HFExtension.m
//  ResaleTreasure
//
//  Created by joyman04 on 16/1/29.
//  Copyright © 2016年 HF. All rights reserved.
//

#import "UIColor+HFExtension.h"

@implementation UIColor (HFExtension)

+(UIColor*)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a{
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
}

@end
