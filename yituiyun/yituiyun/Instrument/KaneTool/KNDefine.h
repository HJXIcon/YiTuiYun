//
//  KNDefine.h
//  NavTest
//
//  Created by LUKHA_Lu on 15/10/9.
//  Copyright (c) 2015年 KNKane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KNAlertView.h"
#import "KNJudgementTool.h"
#import "KNNavigationController.h"
#import "KNRootController.h"
#import "KNShareTextView.h"
#import "KNTitleBtn.h"
#import "UIBarButtonItem+Extension.h"
#import "UIColor+KNColor.h"
#import "UIView+Extension.h"


// 推出  有动画 / 没有动画
#define pushToControllerWithAnimated(name) [self.navigationController pushViewController:name animated:YES];
#define pushToControllerWithoutAnimated(name) [self.navigationController pushViewController:name animated:NO];

// 返回  有动画 / 没有动画
#define popBackWithAnimated [self.navigationController popViewControllerAnimated:YES];
#define popBackWithoutAnimated [self.navigationController popViewControllerAnimated:NO];

// 返回到指定的控制器  有动画 / 没有动画
#define popToDestinationVcWithAnimated(name) [self.navigationController popToViewController:name animated:YES];
#define popToDestinationVcWithoutAnimated(name) [self.navigationController popToViewController:name animated:NO];

// 判断是哪个机型
#define iPhone6P (ScreenWidth == 414)
#define iPhone6 (ScreenWidth == 375)
#define iPhone4 (ScreenHeight == 480)
//#define iPhone5 (ScreenHeight == 568)

// 通过色值去设置颜色 例如: kUIColorFromRGB(0xf9f9f9)
#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 屏幕宽和高
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface KNDefine : NSObject

@end
