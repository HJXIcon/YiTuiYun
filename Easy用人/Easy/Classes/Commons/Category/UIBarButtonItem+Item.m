//
//  UIBarButtonItem+Item.m
//  BuDeJie
//
//  Created by xmg on 16/4/25.
//  Copyright © 2016年 xmg. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)
+ (UIBarButtonItem *)item:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    // 把按钮包装成UIBarButtonItem，点击范围扩大，把按钮放在UIView,在把UIView包装成UIBarButtonItem
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
}
+ (UIBarButtonItem *)item:(UIImage *)image highImage:(UIImage *)highImage target:( id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    // 把按钮包装成UIBarButtonItem，点击范围扩大，把按钮放在UIView,在把UIView包装成UIBarButtonItem
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
}
@end
