//
//  EDocumentCenterImageCell.h
//  Easy
//
//  Created by yituiyun on 2017/12/4.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseTableViewCell.h"

@interface EDocumentCenterImageCell : EBaseTableViewCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, copy) void(^clickImageBlock)(void);
@end
