//
//  EMyTeamViewController.h
//  Easy
//
//  Created by yituiyun on 2017/12/14.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewController.h"

/**
 我的团队
 */
@interface EMyTeamViewController : EBaseViewController
/// --->>> 兼职管理邀请
@property (nonatomic, assign) BOOL isDemandAddMember;
@property (nonatomic, strong) NSString *demandPriceId;
/// --->>> 兼职管理邀请

/// 已经邀请的用户
@property (nonatomic, strong) NSArray <NSString *>*existUserIds;

@end
