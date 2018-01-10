//
//  EControllerManger.m
//  Easy
//
//  Created by yituiyun on 2017/11/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EControllerManger.h"
#import "ENavigationController.h"
#import "ETabBarViewController.h"
#import "ELoginViewController.h"
#import "ERegisterViewController.h"
#import "EHomeViewController.h"
#import "ELaunchViewController.h"

@implementation EControllerManger

+ (UIViewController *)chooseRootController{
    
    if ([EUserInfoManager getUserInfo]) {
        ETabBarViewController *tabBarVc = [[ETabBarViewController alloc]init];
        
        return tabBarVc;
    }
    
    ELoginViewController *loginVc = [[ELoginViewController alloc]init];
    ENavigationController *nav = [[ENavigationController alloc]initWithRootViewController:loginVc];
    return nav;
    
    
}

/// 切换登录
+ (void)turnToLoginController{
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[ENavigationController alloc]initWithRootViewController:[[ELoginViewController alloc]init]];
}

/// 主界面
+ (void)turnToMainController{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[ETabBarViewController alloc]init];
}

+ (void)presentLoginController{
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[ELoginViewController alloc]init] animated:YES completion:nil];
}

+ (void)presentRegisterController{
    UIViewController *topRootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    
    // 在这里加一个这个样式的循环
    while (topRootViewController.presentedViewController) {
        // 这里固定写法
        topRootViewController = topRootViewController.presentedViewController;
    }
    ERegisterViewController *vc = [[ERegisterViewController alloc]init];
    // 然后再进行present操作
    [topRootViewController presentViewController:vc animated:YES completion:nil];
    
}




/**
 拿到当前正在显示的控制器，不管是push进去的，还是present进去的都能拿到
 */
+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc {
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        
        return [self getVisibleViewControllerFrom:[((UINavigationController*) vc) visibleViewController]];
        
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        
        return [self getVisibleViewControllerFrom:[((UITabBarController*) vc) selectedViewController]];
        
    } else {
        
        if (vc.presentedViewController) {
            
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
            
        } else {
            
            return vc;
            
        }
        
    }
    
}



/**
 怎么通过view找到拥有这个View的Controller
 */
+ (UIViewController *)getControllerFormView:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}


@end
