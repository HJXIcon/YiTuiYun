//
//  JXPunchClockListCell.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/12.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXBaseTableViewCell.h"

@class JXPunchClockListModel;
@interface JXPunchClockListCell : JXBaseTableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
//状态栏
@property(nonatomic,strong) UILabel * statusLabel;
@property(nonatomic,strong) UILabel * timeLabel;
//状态btn
@property(nonatomic,strong) UIButton * statusBtn;
/** 查看进度*/
@property (nonatomic, copy) void(^seeProgressBlock)();


/** model*/
@property (nonatomic, strong) JXPunchClockListModel *model;

@end
