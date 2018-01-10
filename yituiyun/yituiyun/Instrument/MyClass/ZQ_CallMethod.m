//
//  ZQ_CallMethod.m
//  社区快线
//
//  Created by 张强 on 15/11/26.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "ZQ_CallMethod.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@implementation ZQ_CallMethod

//返回登录页
+ (void)againLogin
{
    MainViewController *main = nil;
    if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[MainViewController class]]) {
        main = (MainViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        [main againLogin];
    }
}

//刷新首页和发现
+ (void)refreshInterface
{
    MainViewController *main = nil;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.window.rootViewController isKindOfClass:[MainViewController class]]) {
        main = (MainViewController *)appDelegate.window.rootViewController;
        [main setupSubviews];
    }
}

//更新消息数
+ (void)setupNewMessageBoxCount
{
    MainViewController *main = nil;
    if ([[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[MainViewController class]]) {
        main = (MainViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        [main setupUnreadMessageCount];
    }

}

@end
