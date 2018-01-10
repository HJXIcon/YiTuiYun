//
//  EMyTeamViewModel.m
//  Easy
//
//  Created by yituiyun on 2017/12/18.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EMyTeamViewModel.h"
#import "EUserModel.h"


@implementation EMyTeamViewModel
+ (void)getMyGroupMember:(void(^)(NSArray <EMyTeamListModel *>*myTeamLists))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kMyGroupMember) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        
        NSArray *list = @[];
        if ([responseObject[@"errno"] intValue] == 0) {
            list = [EMyTeamListModel mj_objectArrayWithKeyValuesArray:responseObject[@"rst"]];
        }
        
        if (completion) {
            completion(list);
        }
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
}

/**
 领队删除成员
 
 */
+ (void)delGroupMemberWithId:(NSString *)childUserId
                  completion:(void(^)(void))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    params[@"childUserId"] = childUserId;
    
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kDelGroupMember) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        
        [self showHint:responseObject[@"errmsg"]];
        if ([responseObject[@"errno"] intValue] == 0) {
            if (completion) {
                completion();
            }
        }
        
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
}

/**
 项目团队增加成员
 
 @param childUserIdStr childUserId 拼接，用,隔开
 @param demandPriceId demandPriceId
 */
+ (void)demandAddMemberWithChildUserIdStr:(NSString *)childUserIdStr
                            demandPriceId:(NSString *)demandPriceId
                               completion:(void(^)(void))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    params[@"childUserId"] = childUserIdStr;
    params[@"demandPriceId"] = demandPriceId;
    
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kDemandAddMember) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        
        [self showHint:responseObject[@"errmsg"]];
        if ([responseObject[@"errno"] intValue] == 0) {
            if (completion) {
                completion();
            }
        }
        
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];
        [self showFailureMsg];
    }];
}

@end
