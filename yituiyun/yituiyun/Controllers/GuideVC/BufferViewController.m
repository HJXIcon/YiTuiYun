//
//  BufferViewController.m
//  yituiyun
//
//  Created by NIT on 15/6/23.
//  Copyright (c) 2015年 ZQ. All rights reserved.
//

#import "BufferViewController.h"
#import "AdvertisingViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "GuideViewController.h"
@interface BufferViewController ()

/**mainVc */
@property(nonatomic,strong) MainViewController *viewController;

@property (nonatomic, strong) NSDictionary *dic;
@property(nonatomic,strong) BMKLocationService * localServer;


@end

@implementation BufferViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * imageVeiw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    if (iPhone6P) {
        imageVeiw.image = [UIImage imageNamed:@"1242_2208"];
    } else if (iPhone6) {
        imageVeiw.image = [UIImage imageNamed:@"750_1334"];
    } else if (iPhone5) {
        imageVeiw.image = [UIImage imageNamed:@"640_1136"];
    } else if (iPhone4) {
        imageVeiw.image = [UIImage imageNamed:@"640_960"];
    }
    [self.view insertSubview:imageVeiw atIndex:0];
   
    
    
}

-(BMKLocationService *)localServer{
    if (_localServer == nil) {
        _localServer = [[BMKLocationService alloc]init];
        _localServer.delegate = self;
    }
    return _localServer;
}


-(void)startAnimation{
    
    [SVProgressHUD showWithStatus:@"请求数据中..."];
}

-(void)stopAnimation{
    
    [SVProgressHUD dismiss];
}


-(void)showErrorMess:(NSString *)mess{
    
    [SVProgressHUD showErrorWithStatus:mess];
}



//
//
//- (void)obtainServerAddress
//
//{
//    
//    
//    __weak AppDelegate *weakSelf = self;
//    NSString *URL = [NSString stringWithFormat:@"%@%@",originalHost, @"api.php?m=setpdf.domain_list"];
//    [HFRequest requestWithUrl:URL parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
//            
//            NSArray *array = responseObject[@"rst"];
//            int i = (int)array.count;
//            int x = arc4random() % i;
//            NSDictionary *dic = array[x];
//            NSString *string = [NSString stringWithFormat:@"%@/", dic[@"domain_url"]];
//            
//            [USERDEFALUTS setObject:string forKey:@"obtainServerAddress"];
//            [USERDEFALUTS synchronize];
//            
//            //判断引导页是否播放过
//            UserInfoModel *model = [ZQ_AppCache userInfoVo];
//            if ([ZQ_CommonTool isEmpty:model.userID]) {
//                //如果没有则打开引导页
//                GuideViewController *firstVC = [[GuideViewController alloc] init];
//                [UIApplication sharedApplication].keyWindow.rootViewController = firstVC;
//            } else {
//                if (![model.userID isEqualToString:@"0"]) {
//                    
//                    
//                    //                    NSLog(@"=====userid======%@=======",model.userID);
//                    [self determineLoginStatus];
//                } else {
//                    [self loginHomePage];
//                }
//            }
//            
//            //检测版本更新
//            [self versionUpdate];
//            
//            
//            
//            
//        } else {
//            [USERDEFALUTS setObject:originalHost forKey:@"obtainServerAddress"];
//            [USERDEFALUTS synchronize];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [USERDEFALUTS setObject:originalHost forKey:@"obtainServerAddress"];
//        [USERDEFALUTS synchronize];
//        
//        
//
//        
//    }];
//}
//
//
////版 本 更 新
//- (void)versionUpdate
//{
//    __weak BufferViewController *weakSelf = self;
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"type"] = @"system";
//    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost, @"api.php?m=data.config"];
//    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        
//        
//        UserInfoModel *model = [ZQ_AppCache userInfoVo];
//        if (![ZQ_CommonTool isEmpty:model.userID]) {
//            model.rsprice = [NSString stringWithFormat:@"%@", responseObject[@"rsprice"]];
//            model.gzprice = [NSString stringWithFormat:@"%@", responseObject[@"gzprice"]];
//            [ZQ_AppCache save:model];
//        } else {
//            UserInfoModel *model1 = [[UserInfoModel alloc] init];
//            model1.rsprice = [NSString stringWithFormat:@"%@", responseObject[@"rsprice"]];
//            model1.gzprice = [NSString stringWithFormat:@"%@", responseObject[@"gzprice"]];
//            [ZQ_AppCache save:model1];
//        }
//        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        // app版本
//        CGFloat app_Version = [infoDictionary[@"CFBundleShortVersionString"] floatValue];
//        CGFloat server_Version = [responseObject[@"iosVersion"] floatValue];
//        if (app_Version < server_Version) {
//            ZQ_UIAlertView *alertView = [ZQ_UIAlertView showMessage:@"尊敬的用户您好，我们发现您有新版本还没有更新，请您更新之后继续使用。" title:@"更新提示" cancelTitle:@"立即更新" otherButtonTitle:nil];
//            alertView.clickBlock = ^(ZQ_UIAlertView *alertView, NSInteger clickIndex) {
//                //@"itms-apps://itunes.apple.com/app/id1111166351"
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", responseObject[@"iosUrl"]]]];
////                [weakSelf versionUpdate];
//            };
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//    
//}
//- (void)determineLoginStatus
//
//{
//    __weak AppDelegate *weakSelf = self;
//    UserInfoModel *model = [ZQ_AppCache userInfoVo];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"uid"] = model.userID;
//    params[@"t"] = @"auto";
//    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=login"];
//    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
//            NSDictionary *dic = responseObject[@"rst"];
//            
//            NSSet *set;
//            if ([ZQ_CommonTool isEmptyArray:dic[@"tags"]]) {
//                set = [[NSSet alloc] init];
//            } else {
//                set = [NSSet setWithArray:dic[@"tags"]];
//            }
//            
//            
//            [ZQ_AppCache saveUserFriendInfo:dic WithName:dic[@"uid"]];
//            model.userID = [NSString stringWithFormat:@"%@", dic[@"uid"]];
//            model.identity = [NSString stringWithFormat:@"%@", dic[@"uModelid"]];
//            model.avatar = [NSString stringWithFormat:@"%@", dic[@"avatar"]];
//            model.nickname = [NSString stringWithFormat:@"%@", dic[@"nickname"]];
//            model.isSeeTel = [NSString stringWithFormat:@"%@", dic[@"isSeeTel"]];
//            model.isChange = [NSString stringWithFormat:@"%@", dic[@"isChange"]];
//            model.jobType = [NSString stringWithFormat:@"%@", dic[@"jobType"]];
//            [ZQ_AppCache save:model];
//            
//            [JPUSHService setTags:set alias:model.userID callbackSelector:nil object:nil];
//            
//            [weakSelf loginHomePage];
//            
//            if ([model.identity integerValue] == 6) {
//                [MobClick event:@"loginNums_BD"];
//            } else if ([model.identity integerValue] == 5) {
//                [MobClick event:@"loginNums_company"];
//            }
//            
//            //登录环信
//            [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"%@", dic[@"uid"]] password:[NSString stringWithFormat:@"%@", dic[@"uid"]] completion:^(NSString *aUsername, EMError *aError) {
//                if (!aError) {
//                    if (_viewController) {
//                        [_viewController setupUnreadMessageCount];
//                    }
//                    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
//                        if (!aError) {
//                            [self getFriends:aList];
//                        }
//                    }];
//                }
//            }];
//        } else {
//            model.userID = @"0";
//            model.identity = @"6";
//            [ZQ_AppCache save:model];
//            [JPUSHService setTags:[NSSet set] alias:@"" callbackSelector:nil object:nil];
//            [weakSelf loginHomePage];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        model.userID = @"0";
//        model.identity = @"6";
//        [ZQ_AppCache save:model];
//        [JPUSHService setTags:[NSSet set] alias:@"" callbackSelector:nil object:nil];
//        [weakSelf loginHomePage];
//    }];
//}
//
//- (void)getFriends:(NSArray *)array
//{
//    NSString *uids = nil;
//    for (NSString *string in array) {
//        if ([ZQ_CommonTool isEmpty:uids]) {
//            uids = [NSString stringWithFormat:@"%@", string];
//        } else {
//            uids = [NSString stringWithFormat:@"%@,%@", uids, string];
//        }
//    }
//    UserInfoModel *model = [ZQ_AppCache userInfoVo];
//    __weak AppDelegate *weakSelf = self;
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"uid"] = model.userID;
//    params[@"uids"] = uids;
//    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost, @"api.php?m=freinds.freinds_list"];
//    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        if ([responseObject[@"errno"] integerValue] == 0) {
//            NSDictionary *dic = responseObject[@"rst"];
//            NSString *string = [NSString stringWithFormat:@"%@", dic[@"nums"]];
//            [USERDEFALUTS setInteger:[string integerValue] forKey:@"allyCircleCount"];
//            [USERDEFALUTS synchronize];
//            if (_viewController) {
//                [_viewController setupUnreadMessageCount];
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        
//        
//    }];
//}
//
//
//- (void)loginHomePage {
//    if (!self.viewController) {
//        self.viewController = [[MainViewController alloc] init];
//    }
//    [UIApplication sharedApplication].keyWindow.rootViewController = self.viewController;
//    
//    if (_dic != nil) {
////        [self.viewController jumpAPP:_dic];
//    }
//}
//
//
//
//- (void)NetworkRequest
//{
////    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
////    AddressVo *covo = [ZQ_AppCache addressVo];
////    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
////    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[USERDEFALUTS objectForKey:@"device"]];
////    params[@"reqCode"] = @"0505";
////    params[@"community"] = covo.communityId;
////    params[@"user"] = [USERDEFALUTS objectForKey:@"userid"];
////    params[@"sign"] = @"";
////    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost,kHomeAdvertURL];
////    [manager GET:URL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
////        if ([responseObject[@"repCode"] isEqualToString:@"00"]) {
////            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
////            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", responseObject[@"imgLink"]]]]];
////            dic[@"imgLink"] = image;
////            if ([responseObject[@"show"] integerValue] == 1) {
////                AdvertisingViewController *advertisingVC = [[AdvertisingViewController alloc] initWithDic:dic];
////                appDelegate.window.rootViewController = advertisingVC;
////            } else {
////                [appDelegate loginHomePage];
////            }
////        } else {
////            [appDelegate loginHomePage];
////        }
////    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        [appDelegate loginHomePage];
////    }];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
@end
