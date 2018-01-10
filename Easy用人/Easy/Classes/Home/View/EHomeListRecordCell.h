//
//  EHomeListRecordCell.h
//  Easy
//
//  Created by yituiyun on 2017/11/27.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseTableViewCell.h"
@class EHomeListModel;
/**
 打卡记录
 */
@interface EHomeListRecordCell : EBaseTableViewCell
@property (nonatomic, strong) EHomeListModel *model;
@end
