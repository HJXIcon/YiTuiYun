//
//  EPerfectInfoCell.h
//  Easy
//
//  Created by yituiyun on 2017/11/21.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseTableViewCell.h"

@interface EPerfectInfoCell : EBaseTableViewCell

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLablel;
@property (nonatomic, strong) UITextField *rightTextF;
@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, copy) void(^rightTextFeildBlock)(NSString *text);
@end
