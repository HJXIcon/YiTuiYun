//
//  EMyTeamViewModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/18.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewModel.h"
#import "EMyTeamListModel.h"

@class EUserModel;
@interface EMyTeamViewModel : EBaseViewModel

/**
 获取我的团队成员
 */
+ (void)getMyGroupMember:(void(^)(NSArray <EMyTeamListModel *>*myTeamLists))completion;

/**
 领队删除成员

 */
+ (void)delGroupMemberWithId:(NSString *)childUserId
                  completion:(void(^)(void))completion;

/**
 项目团队增加成员

 @param childUserIdStr childUserId 拼接，用,隔开
 @param demandPriceId demandPriceId
 */
+ (void)demandAddMemberWithChildUserIdStr:(NSString *)childUserIdStr
                            demandPriceId:(NSString *)demandPriceId
                               completion:(void(^)(void))completion;




@end
