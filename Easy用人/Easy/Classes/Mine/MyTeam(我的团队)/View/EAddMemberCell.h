//
//  EAddMemberCell.h
//  Easy
//
//  Created by yituiyun on 2017/12/18.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseTableViewCell.h"

@class EUserModel;
@interface EAddMemberCell : EBaseTableViewCell

@property (nonatomic, strong) EUserModel *model;
@property (nonatomic, copy) void(^addBlock)(void);

@end
