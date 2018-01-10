//
//  EPerfectInfoSexCell.h
//  Easy
//
//  Created by yituiyun on 2017/11/21.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseTableViewCell.h"


@interface EPerfectInfoSexCell : EBaseTableViewCell
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, copy) void(^sexBlock)(NSString *sex);
@property (nonatomic, copy) void(^iconTapBlock)(void);
/// 0:女，1:男
@property (nonatomic, strong) NSString *sex;

+ (CGFloat)cellHeight;
@end
