//
//  AppDelegate.h
//  yituiyun
//
//  Created by 张强 on 16/10/10.
//  Copyright © 2016年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WXApiObject.h"

@class MainViewController;

static NSString *appKey = @"4cba94918cee1ba749372b13";
static NSString *channel = @"AppStore";
#ifdef DEBUG // 开发
static BOOL const isProduction = FALSE; // 极光FALSE为开发环境
#else // 生产
static BOOL const isProduction = TRUE; // 极光TRUE为生产环境
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    enum WXScene _scene;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MainViewController *viewController;
- (void)loginHomePage;
- (void)loginAdvertising:(NSDictionary *)dic;

@end

