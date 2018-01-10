//
//  EControllerManger.h
//  Easy
//
//  Created by yituiyun on 2017/11/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EControllerManger : NSObject

+ (UIViewController *)chooseRootController;
/// 切换登录
+ (void)turnToLoginController;
/// 主界面
+ (void)turnToMainController;

+ (void)presentLoginController;

+ (void)presentRegisterController;
/**
 拿到当前正在显示的控制器，不管是push进去的，还是present进去的都能拿到
 */
+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc;
/**
 怎么通过view找到拥有这个View的Controller
 */
+ (UIViewController *)getControllerFormView:(UIView *)view;

//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController;

@end
