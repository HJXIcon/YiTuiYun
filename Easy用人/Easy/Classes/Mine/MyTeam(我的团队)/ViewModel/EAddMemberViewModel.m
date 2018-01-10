//
//  EAddMemberViewModel.m
//  Easy
//
//  Created by yituiyun on 2017/12/18.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EAddMemberViewModel.h"
#import "EUserModel.h"

@implementation EAddMemberViewModel
/**
 搜索用户（通过手机号码）
 
 @param mobile 手机号
 */
+ (void)searchMemberWithMobile:(NSString *)mobile completion:(void(^)(EUserModel *model))completion{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    params[@"mobile"] = mobile;
    
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kSearchMember) parameters:params success:^(NSDictionary *responseObject) {
        [self jx_dimissLoadingAnimation];
        
        /// 无值
        if ([responseObject[@"errno"] intValue] == 0 && kDictIsEmpty(responseObject[@"rst"])) {
            [self showHint:@"找不到该用户"];
            return ;
        }
        
        if ([responseObject[@"errno"] intValue] == 0) {
            EUserModel *model = [EUserModel mj_objectWithKeyValues:responseObject[@"rst"]];
            if (completion) {
                completion(model);
            }
        }
        else{
            
            [self showHint:responseObject[@"errmsg"]];
        }
        
        
    } failure:^(NSError *error) {
        [self jx_dimissLoadingAnimation];

        [self showFailureMsg];
    }];
}


/**
 领队添加成员！
 @param childUserId 成员id
 */
+ (void)addGroupMemberWithChildUserId:(NSString *)childUserId completion:(void(^)(void))completion{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    params[@"childUserId"] = childUserId;
    
    [self jx_showLoadingAnimation];
    [PPNetworkHelper POST:E_ApiRequset(kAddGroupMember) parameters:params success:^(NSDictionary *responseObject) {
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
