//
//  EMineHeaderView.h
//  Easy
//
//  Created by yituiyun on 2017/11/30.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EUserModel;

@interface EMineHeaderView : UIImageView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) EUserModel *userModel;
/// 申请带队
@property (nonatomic, strong) UIButton *addGroupBtn;

@property (nonatomic, copy) void(^headerBlock)(void);
@property (nonatomic, copy) void(^phoneBlock)(void);
@property (nonatomic, copy) void(^addGroupBlock)(void);
@end
