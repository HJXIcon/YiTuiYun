//
//  EAddMemberViewModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/18.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewModel.h"

@class EUserModel;
@interface EAddMemberViewModel : EBaseViewModel

/**
 搜索用户（通过手机号码）

 @param mobile 手机号
 */
+ (void)searchMemberWithMobile:(NSString *)mobile completion:(void(^)(EUserModel *model))completion;

/**
 领队添加成员！
 @param childUserId 成员id
 */
+ (void)addGroupMemberWithChildUserId:(NSString *)childUserId completion:(void(^)(void))completion;
@end
