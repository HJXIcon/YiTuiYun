//
//  EHomeListWagesCell.h
//  Easy
//
//  Created by yituiyun on 2017/11/24.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseTableViewCell.h"

/**
 工资、筛选View
 */
@interface EHomeListWagesHeaderView : UIView
@property (nonatomic, strong) UILabel *wagesLabel;
@property (nonatomic, copy) void(^filterBlock)(void);
@end
