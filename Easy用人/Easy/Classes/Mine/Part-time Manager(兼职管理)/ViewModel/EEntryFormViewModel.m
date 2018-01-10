//
//  EEntryFormViewModel.m
//  Easy
//
//  Created by yituiyun on 2017/12/15.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EEntryFormViewModel.h"
#import "EUserModel.h"

@implementation EEntryFormViewModel

/**
 获取已在项目中的团队成员userId
 */
+ (void)demandGroupMemberWithDemandPriceId:(NSString *)demandPriceId completion:(void(^)(NSArray <NSString *>*userIds))completion{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [EUserInfoManager getUserInfo].userId;
    params[@"demandPriceId"] = demandPriceId;
    
    [PPNetworkHelper POST:E_ApiRequset(kDemandGroupMember) parameters:params success:^(NSDictionary *responseObject) {
        
        
        if ([responseObject[@"errno"] intValue] != 0) {
            if (completion) {
                completion(nil);
            }
            return ;
        }
        
        if (completion) {
            NSMutableArray <NSString *>*array = [NSMutableArray array];
            NSArray *numArray = responseObject[@"rst"];
            [numArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:[NSString stringWithFormat:@"%@",obj]];
            }];
            completion(array);
        }
        
    } failure:^(NSError *error) {
        
        if (completion) {
            completion(nil);
        }
        [self showHint:@"请求失败，请重试"];
        
    }];

}
@end
