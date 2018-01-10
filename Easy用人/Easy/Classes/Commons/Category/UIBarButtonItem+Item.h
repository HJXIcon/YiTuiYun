//
//  UIBarButtonItem+Item.h
//  BuDeJie
//
//  Created by xmg on 16/4/25.
//  Copyright © 2016年 xmg. All rights reserved.
//

@interface UIBarButtonItem (Item)

// 快速创建UIBarButtonItem
+ (UIBarButtonItem *)item:(UIImage *)image highImage:(UIImage *)highImage target:( id)target action:(SEL)action;

+ (UIBarButtonItem *)item:(UIImage *)image selImage:(UIImage *)selImage target:( id)target action:(SEL)action;


@end
