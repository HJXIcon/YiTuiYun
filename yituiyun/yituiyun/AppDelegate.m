//
//  AppDelegate.m
//  yituiyun
//
//  Created by 张强 on 16/10/10.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "GuideViewController.h"
#import "BufferViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <UserNotifications/UserNotifications.h>
//微信支付
#import "payRequsestHandler.h"
#import <QuartzCore/QuartzCore.h>
//支付宝支付
#import <AlipaySDK/AlipaySDK.h>
//银联
#import "UPPaymentControl.h"
#import <CommonCrypto/CommonDigest.h>
#import <Bugly/Bugly.h>

#define EaseMobAppKey @"1185160929115145#yituiyun"


@interface AppDelegate ()<JPUSHRegisterDelegate>
{
    BMKMapManager* _mapManager;
}

@property (nonatomic, strong) NSDictionary *dic;

/**遮盖Vc */
@property(nonatomic,strong) BufferViewController * bufferVc;


@end

@implementation AppDelegate


- (instancetype)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}
//推 送
- (void)JPushTrack:(NSDictionary *)launchOptions {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //长连接，匿名消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            // iOS10获取registrationID放到这里了, 可以存到缓存里, 用来标识用户单独发送推送
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
}

//分 享
- (void)shareSDK
{
   
    [ShareSDK registerApp:@"182e66d53423c"
          activePlatforms:@[@(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              //@"wx6ec7a8ca62258816"

              switch (platformType)
              {
                  case SSDKPlatformTypeWechat:
                      //微信平台
                      [appInfo SSDKSetupWeChatByAppId:WechatAppID
                                            appSecret:@"c876dbed43e797de485674a2962e06e5"];
                      break;
                  case SSDKPlatformTypeQQ:
                      //QQ平台
                      [appInfo SSDKSetupQQByAppId:@"1105831738"
                                           appKey:@"43WUspQz2HHhfWw8"
                                         authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
              
          }];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    //bugly统计
    [Bugly startWithAppId:@"67a7204c39"];

    //状态栏显示
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //状态栏变白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.dic = nil;
    //极光推送
    [self JPushTrack:launchOptions];
    //分享
    [self shareSDK];
    //微信支付
    [WXApi registerApp:WechatAppID withDescription:@"yituiyun"];
    
    UMConfigInstance.appKey = @"5864eb81cae7e73d72001086";
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick event:@"appLaucherNums"];

    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
#warning 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"ceshituisongzhengshu";
#else
    apnsCertName = @"zhengshituisongzhengshu";
#endif
    [[RedPacketUserConfig sharedConfig] configWithAppKey:EaseMobAppKey];

//    [[EMClient sharedClient] getPushNotificationOptionsFromServerWithCompletion:nil];
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:EaseMobAppKey
                                         apnsCertName:apnsCertName
                                          otherConfig:nil];
    
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:@"5I9f5xQb12qerHV6wMjWqpK3G9X4d546"  generalDelegate:nil];
    [self.window makeKeyAndVisible];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    
    BufferViewController *bufferVC = [[BufferViewController alloc] init];
    self.bufferVc = bufferVC;
    self.window.rootViewController = bufferVC;
    [self.window makeKeyAndVisible];
    [self obtainServerAddress];
    
    
    return YES;
}



- (void)obtainServerAddress

{
    //不是第一次打开app
    
    
    [self.bufferVc startAnimation];
    
    __weak AppDelegate *weakSelf = self;
    NSString *URL = [NSString stringWithFormat:@"%@%@",originalHost, @"api.php?m=setpdf.domain_list"];
    [HFRequest requestWithUrl:URL parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        
        [self.bufferVc stopAnimation];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
           
            NSArray *array = responseObject[@"rst"];
            int i = (int)array.count;
            int x = arc4random() % i;
            NSDictionary *dic = array[x];
            NSString *string = [NSString stringWithFormat:@"%@/", dic[@"domain_url"]];
            
            [USERDEFALUTS setObject:string forKey:@"obtainServerAddress"];
            [USERDEFALUTS synchronize];
            
            //判断引导页是否播放过
            UserInfoModel *model = [ZQ_AppCache userInfoVo];
            if ([ZQ_CommonTool isEmpty:model.userID]) {
                //如果没有则打开引导页
                GuideViewController *firstVC = [[GuideViewController alloc] init];
                self.window.rootViewController = firstVC;
            } else {
                if (![model.userID isEqualToString:@"0"]) {
                    
                    

                    [self determineLoginStatus];
                } else {
                    [self loginHomePage];
                }
            }
            
         
            
        } else {
            [USERDEFALUTS setObject:originalHost forKey:@"obtainServerAddress"];
            [USERDEFALUTS synchronize];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [USERDEFALUTS setObject:originalHost forKey:@"obtainServerAddress"];
        [USERDEFALUTS synchronize];
       
        [self.bufferVc stopAnimation];
        [self.bufferVc showErrorMess:@"网络连接异常"];
        
        
        

    }];
}

- (void)determineLoginStatus


{
    __weak AppDelegate *weakSelf = self;
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = model.userID;
    params[@"t"] = @"auto";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=login"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *dic = responseObject[@"rst"];

            NSSet *set;
            if ([ZQ_CommonTool isEmptyArray:dic[@"tags"]]) {
                set = [[NSSet alloc] init];
            } else {
                set = [NSSet setWithArray:dic[@"tags"]];
            }
            
        
            [ZQ_AppCache saveUserFriendInfo:dic WithName:dic[@"uid"]];
            model.userID = [NSString stringWithFormat:@"%@", dic[@"uid"]];
            model.identity = [NSString stringWithFormat:@"%@", dic[@"uModelid"]];
            model.avatar = [NSString stringWithFormat:@"%@", dic[@"avatar"]];
            model.nickname = [NSString stringWithFormat:@"%@", dic[@"nickname"]];
            model.isSeeTel = [NSString stringWithFormat:@"%@", dic[@"isSeeTel"]];
            model.isChange = [NSString stringWithFormat:@"%@", dic[@"isChange"]];
            model.jobType = [NSString stringWithFormat:@"%@", dic[@"jobType"]];
            [ZQ_AppCache save:model];
            
            [JPUSHService setTags:set alias:model.userID callbackSelector:nil object:nil];
            
            
            
            [weakSelf loginHomePage];
            
            if ([model.identity integerValue] == 6) {
                [MobClick event:@"loginNums_BD"];
            } else if ([model.identity integerValue] == 5) {
                [MobClick event:@"loginNums_company"];
            }
            
            //登录环信
            [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"%@", dic[@"uid"]] password:[NSString stringWithFormat:@"%@", dic[@"uid"]] completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    if (_viewController) {
                        [_viewController setupUnreadMessageCount];
                    }
                    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
                        if (!aError) {
                            [self getFriends:aList];
                        }
                    }];
                }
            }];
        } else {
            model.userID = @"0";
            model.identity = @"6";
            [ZQ_AppCache save:model];
            [JPUSHService setTags:[NSSet set] alias:@"" callbackSelector:nil object:nil];
            [weakSelf loginHomePage];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        model.userID = @"0";
        model.identity = @"6";
        [ZQ_AppCache save:model];
        [JPUSHService setTags:[NSSet set] alias:@"" callbackSelector:nil object:nil];
        [weakSelf loginHomePage];
    }];
}

- (void)getFriends:(NSArray *)array
{
    NSString *uids = nil;
    for (NSString *string in array) {
        if ([ZQ_CommonTool isEmpty:uids]) {
            uids = [NSString stringWithFormat:@"%@", string];
        } else {
            uids = [NSString stringWithFormat:@"%@,%@", uids, string];
        }
    }
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    __weak AppDelegate *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = model.userID;
    params[@"uids"] = uids;
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost, @"api.php?m=freinds.freinds_list"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"errno"] integerValue] == 0) {
            NSDictionary *dic = responseObject[@"rst"];
            NSString *string = [NSString stringWithFormat:@"%@", dic[@"nums"]];
            [USERDEFALUTS setInteger:[string integerValue] forKey:@"allyCircleCount"];
            [USERDEFALUTS synchronize];
            if (_viewController) {
                [_viewController setupUnreadMessageCount];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
    }];
}

- (void)loginHomePage {
   
    
    if (!self.viewController) {
        self.viewController = [[MainViewController alloc] init];
    }
    self.window.rootViewController = self.viewController;

    if (_dic != nil) {
        [self.viewController jumpAPP:_dic];
    }
}

- (void)loginAdvertising:(NSDictionary *)dic {
    NSDictionary *dicc = [NSDictionary dictionaryWithDictionary:dic];
    if (!self.viewController) {
        self.viewController = [[MainViewController alloc] init];
    }
    self.window.rootViewController = self.viewController;
    
    //跳转APP自己界面
    if ([dicc[@"jumpType"] integerValue] == 1) {
        [self.viewController jumpAPP:dicc];
        //跳转H5
    } else if ([dicc[@"jumpType"] integerValue] == 2) {
        [self.viewController jumpH5:dicc];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    
}
#pragma mark--支付回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
   
    
    if ([url.scheme isEqualToString:@"YiTuiYun"]) {
        return YES;
    } else {
        NSString *str = [USERDEFALUTS objectForKey:@"payStyle"];
        if([str isEqualToString:@"ali"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"delegate:%@",resultDic);
                NSString *str = resultDic[@"resultStatus"];
                if([str isEqualToString:@"9000"]){ // 支付成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPaySuccess" object:nil];
                }else{ // 支付失败
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayFailure" object:nil];
                }
            }];
            
        } else if([str isEqualToString:@"wechat"]){
            return  [WXApi handleOpenURL:url delegate:self];
        } else if([str isEqualToString:@"unionpay"]){
            return [self unionpayOpenURL:url];
        }
    }
    return YES;
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"失败");
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

    
    if ([url.scheme isEqualToString:@"YiTuiYun"]) {
        return YES;
    } else {
        NSString *str = [USERDEFALUTS objectForKey:@"payStyle"];
        if ([str isEqualToString:@"ali"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"delegate:%@",resultDic);
                NSString *str = resultDic[@"resultStatus"];
                if([str isEqualToString:@"9000"]){ // 支付成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPaySuccess" object:nil];
                }else{ // 支付失败
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayFailure" object:nil];
                }
                
            }];
            
        } else if([str isEqualToString:@"wechat"]){
            return  [WXApi handleOpenURL:url delegate:self];
        } else if([str isEqualToString:@"unionpay"]){
            return [self unionpayOpenURL:url];
        }
    }
    return YES;
}

- (BOOL)application:(UIApplication*)app openURL:(NSURL*)url options:(NSDictionary *)options
{
    
   
    if ([url.scheme isEqualToString:@"YiTuiYun"]) {
        return YES;
    } else {
        NSString *str = [USERDEFALUTS objectForKey:@"payStyle"];
        if ([str isEqualToString:@"ali"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSString *str = resultDic[@"resultStatus"];
                if([str isEqualToString:@"9000"]){ // 支付成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPaySuccess" object:nil];
                }else{ // 支付失败
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayFailure" object:nil];
                }
                
            }];
            
        } else if([str isEqualToString:@"wechat"]){
            return [WXApi handleOpenURL:url delegate:self];
        } else if([str isEqualToString:@"unionpay"]){
            return [self unionpayOpenURL:url];
        }
    }
    return YES;
}

-(void) onResp:(BaseResp*)resp
{
   
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatPaySuccess" object:nil];
                break;
                
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatPayFailure" object:nil];
                break;
        }
    }
}

- (BOOL)unionpayOpenURL:(NSURL*)url
{
    
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        
        //结果code为成功时，先校验签名，校验成功后做后续处理
        if([code isEqualToString:@"success"]) {
            //判断签名数据是否存在
            if(data == nil){
                //如果没有签名数据，建议商户app后台查询交易结果
                return;
            }
            //数据从NSDictionary转换为NSString
            NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                               options:0
                                                                 error:nil];
            NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
            //验签证书同后台验签证书
            //此处的verify，商户需送去商户后台做验签
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unionpaySuccess" object:sign];
            
            
        } else if([code isEqualToString:@"fail"]) {
            //交易失败
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unionpayFailure" object:nil];

        } else if([code isEqualToString:@"cancel"]) {
            //交易取消
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unionpayFailure" object:nil];
        }
    }];
    
    return YES;
}



#pragma mark--通知调用

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[EMClient sharedClient] registerForRemoteNotificationsWithDeviceToken:deviceToken completion:nil];
    [JPUSHService registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到iOS7以下通知:%@", [self logDic:userInfo]);
    if ([self.window.rootViewController isKindOfClass:[MainViewController class]]) {
        MainViewController *main = (MainViewController *)self.window.rootViewController;
        [main jumpAPP:userInfo];
    } else {
        self.dic = [NSDictionary dictionaryWithDictionary:userInfo];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"收到iOS7以上通知:%@", [self logDic:userInfo]);
    if ([self.window.rootViewController isKindOfClass:[MainViewController class]]) {
        MainViewController *main = (MainViewController *)self.window.rootViewController;
        [main jumpAPP:userInfo];
    } else {
        self.dic = [NSDictionary dictionaryWithDictionary:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    if ([self.window.rootViewController isKindOfClass:[MainViewController class]]) {
        MainViewController *main = (MainViewController *)self.window.rootViewController;
        [main didReceiveLocalNotification:notification];
    }
}

#pragma mark---用户长链接的

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"----chang链接---%@", [self logDic:userInfo]);
    if ([self.window.rootViewController isKindOfClass:[MainViewController class]]) {
        MainViewController *main = (MainViewController *)self.window.rootViewController;
        [main customMessage:userInfo];
    }
}

//转换显示文字
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
        return str;
}





@end
