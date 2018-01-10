//
//  EUserInfoManager.h
//  Easy
//
//  Created by yituiyun on 2017/12/6.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EUserModel;
@interface EUserInfoManager : NSObject
/// 保存用户信息
+ (void)saveUserInfo:(EUserModel *)userModel;

+ (EUserModel *)getUserInfo;

+ (void)removeUserInfo;

/**
 更新用户信息
 */
+ (void)updateUserInfo:(void(^)(void))completion;

+ (BOOL)isLogin;

@end
