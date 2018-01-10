//
//  UIBarButtonItem+Extension.m
//  妈咪宝贝
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

#import "KNTitleBtn.h" // 这个是为了完成任务才加的,

@implementation UIBarButtonItem (Extension)


+ (instancetype)itemWithImage:(NSString *)image selectedImage:(NSString *)selImage target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selImage] forState:UIControlStateHighlighted];
    
    btn.size = btn.currentBackgroundImage.size;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:btn];
}

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kUIColorFromRGB(0xfb7caf) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.frame = CGRectMake(0, 0, 35, 30);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:btn];
}

+ (instancetype)itemBigWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kUIColorFromRGB(0xfb7caf) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:15];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:btn];
}

+ (instancetype)itemChangeLocationWithImage:(NSString *)image title:(NSString *)title  target:(id)target action:(SEL)action{
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, 60, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 0, 54, 44);
    [btn setTitle:title forState:UIControlStateNormal];
    
    UIImage *img = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.adjustsImageWhenHighlighted = NO;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return [[self alloc] initWithCustomView:view];
    
}

@end
