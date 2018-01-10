//
//  EEntryFormViewModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/15.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewModel.h"

@interface EEntryFormViewModel : EBaseViewModel

/**
 获取已在项目中的团队成员userId
 */
+ (void)demandGroupMemberWithDemandPriceId:(NSString *)demandPriceId completion:(void(^)(NSArray <NSString *>*userIds))completion;

@end
