//
//  UIColor+Extension.h
//  JXProjectFramework
//
//  Created by mac on 17/5/19.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorWithHexString:(NSString *)string;
+ (UIColor *)colorWithHexString:(NSString *)string alpha:(CGFloat)alpha;

@end
