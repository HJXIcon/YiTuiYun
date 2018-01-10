//
//  EUserInfoManager.m
//  Easy
//
//  Created by yituiyun on 2017/12/6.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EUserInfoManager.h"
#import "EUserModel.h"

#define KNACCOUNTPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.data"]

@implementation EUserInfoManager
/// 保存用户信息
+ (void)saveUserInfo:(EUserModel *)userModel{
    [NSKeyedArchiver archiveRootObject:userModel toFile:KNACCOUNTPATH];
}

+ (EUserModel *)getUserInfo{
    EUserModel *userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:KNACCOUNTPATH];
    return userInfo;
}
+ (void)removeUserInfo{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:KNACCOUNTPATH error:nil];
}


/**
 更新用户信息
 */
+ (void)updateUserInfo:(void(^)(void))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    [PPNetworkHelper POST:E_ApiRequset(kGetMemberInfo) parameters:params success:^(NSDictionary *responseObject) {
        if ([responseObject[@"errno"] intValue] == 0) {
            EUserModel *model = [EUserModel mj_objectWithKeyValues:responseObject[@"rst"]];
            [EUserInfoManager saveUserInfo:model];
            if (completion) {
                completion();
            }
            
        }else{
            
            [[EControllerManger currentViewController]showHint:responseObject[@"errmsg"]];
        }
        
    } failure:^(NSError *error) {
        
        [[EControllerManger currentViewController]showHint:@"更新个人信息失败，请重试"];
    }];
}

+ (BOOL)isLogin{
    return [self getUserInfo] != nil;
}
@end
