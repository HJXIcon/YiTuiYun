//
//  AppDelegate.m
//  Easy
//
//  Created by yituiyun on 2017/11/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "AppDelegate.h"
#import "EControllerManger.h"
#import <IQKeyboardManager.h>
#import "ELaunchViewController.h"
#import "EGuideViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
//    self.window.rootViewController = [EControllerManger chooseRootController];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:EGuidePageKey]) {
         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EGuidePageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.window.rootViewController = [[EGuideViewController alloc]init];
    }else{
        
        self.window.rootViewController = [[ELaunchViewController alloc]init];
    }
    
    
    [self.window makeKeyAndVisible];
    
    
    [WXApi registerApp:WechatAppID];
    
    
//    [self setupUM];
    
    /// 键盘
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysHide;
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    
    
    
    
    return YES;
}


#pragma mark - *** 友盟
//- (void)setupUM{
//    /* 打开调试日志 */
//    [[UMSocialManager defaultManager] openLog:YES];
//    /* 设置友盟appkey */
//    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppleKey];
//    [self configUSharePlatforms];
//    [self confitUShareSettings];
//}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

//- (void)configUSharePlatforms
//{
//    /*
//     设置微信的appKey和appSecret
//     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx40fc8b8a0744c4fe" appSecret:@"a1527234bbac0cf7767ef9bd97f8948f" redirectURL:nil];
//
//     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:@"wx40fc8b8a0744c4fe" appSecret:@"a1527234bbac0cf7767ef9bd97f8948f" redirectURL:nil];
//
//    /* 设置分享到QQ互联的appID
//     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//     100424468.no permission of union id
//     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
//     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//
//
//    /*
//     * 移除相应平台的分享，如微信收藏
//     */
//    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite),@(UMSocialPlatformType_Sms),@(UMSocialPlatformType_Email)]];
//}
// 设置系统回调
//// 支持所有iOS系统
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}


#pragma mark - *** WXApiDelegate
- (void)onReq:(BaseReq *)req{
    
}

- (void)onResp:(BaseResp *)resp{
    //判断是否为授权请求，否则与微信支付等功能发生冲突
    if ([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0)
        {
            JXLog(@"code === %@",aresp.code);
            [[NSNotificationCenter defaultCenter] postNotificationName:WechatDidLoginNotificationName object:self userInfo:@{@"code":aresp.code}];
        }
    }
}


#pragma mark -
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
