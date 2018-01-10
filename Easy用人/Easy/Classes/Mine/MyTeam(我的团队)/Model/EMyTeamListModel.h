//
//  EMyTeamListModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/18.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMyTeamListModel : NSObject

@property (nonatomic, strong) NSString *childUserName;
@property (nonatomic, strong) NSString *childUserId;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *childUserMobile;
@property (nonatomic, strong) NSString *childUserAvatar;

/// 是否选中
@property (nonatomic, assign) BOOL isSelect;

@end
