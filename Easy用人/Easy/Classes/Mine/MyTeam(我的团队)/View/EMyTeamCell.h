//
//  EMyTeamCell.h
//  Easy
//
//  Created by yituiyun on 2017/12/18.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseTableViewCell.h"
@class EMyTeamListModel;

@interface EMyTeamCell : EBaseTableViewCell

@property (nonatomic, strong) EMyTeamListModel *model;
@property (nonatomic, strong) UIButton *selectBtn;

@end
