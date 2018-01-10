//
//  PUBLIC.h
//  QJIPHONE
//
//  Created by Messi on 14-2-10.
//  Copyright (c) 2014年 Messi. All rights reserved.
//

//UIalertView
#define ALERT_MSG(title,msg)\
{\
UIAlertView*_alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];\
[_alert show];\
}

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//RGB Color
#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//frame
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define iPhone5  ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen]currentMode].size):NO)

#define ZQ_RECT_CREATE(x,y,w,h) CGRectMake(x,y,w,h)
#define ZQ_Device_Width  ([[UIScreen mainScreen] bounds].size.width)
#define ZQ_Device_Height ([[UIScreen mainScreen] bounds].size.height)

//机型
#define IOS7_OR_LATER	[[[UIDevice currentDevice] systemVersion]floatValue] >= 7
#define IOS8_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue] >= 7

//通知
#define NOTIFICENTER  [NSNotificationCenter defaultCenter]

//本地存储
#define USERDEFALUTS  [NSUserDefaults standardUserDefaults]


#define UserDefaultsSet(key,value) [[NSUserDefaults standardUserDefaults] setValue:value forKey:key]
#define UserDefaultsGet(key) [[NSUserDefaults standardUserDefaults] valueForKey:key]

//主色
#define MainColor     [UIColor colorWithR:241 G:97 B:86 alpha:1]


#define NSEaseLocalizedString(key, comment) [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"EaseUIResource" withExtension:@"bundle"]] localizedStringForKey:(key) value:@"" table:nil]

#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2

//网络请求
//主
#define kHost   [USERDEFALUTS objectForKey:@"obtainServerAddress"]
//#define kHost           @"http://115.28.196.154:805/"

#if DEBUG
#define originalHost           @"http://dev.yituiyun.cn/"
#define WechatAppID            @"wxcc71178d9f682177"
#define UipayCode              @"01"

#else
#define originalHost         @"http://app.i.yituiyun.cn/"
#define WechatAppID           @"wx6ec7a8ca62258816"
#define UipayCode              @"00"
#endif





#define UserId      @"userId"        //用户id
#define Code        @"code"          //验证码
#define CodeTime    @"codeTime"      //验证码有效时间
#define IsPush      @"isPush"        //推送开关
#define ServiceTel  @"serviceTel"    //客服电话
#define ServiceEmail @"serviceEmain" //客服邮箱

#define UserAccountTel @"UserAccountTel"

#import "NSString+JXExtension.h"
#import "JXConst.h"
#import "JXLocationTool.h"
#import "JXFactoryTool.h"
#import "UIView+masonry.h"

