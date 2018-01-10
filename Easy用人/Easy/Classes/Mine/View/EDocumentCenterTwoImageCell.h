//
//  EDocumentCenterTwoImageCell.h
//  Easy
//
//  Created by yituiyun on 2017/12/4.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseTableViewCell.h"

@interface EDocumentCenterTwoImageCell : EBaseTableViewCell
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, copy) void(^clickLeftImgBlock)(void);
@property (nonatomic, copy) void(^clickRightImgBlock)(void);
@end
