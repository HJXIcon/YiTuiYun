//
//  EPartManagerCell.h
//  Easy
//
//  Created by yituiyun on 2017/12/11.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseTableViewCell.h"

@class EPartManagerModel;
@interface EPartManagerCell : EBaseTableViewCell

@property (nonatomic, strong) EPartManagerModel *model;
@property (nonatomic, copy) void(^signBlock)(void);
@end
