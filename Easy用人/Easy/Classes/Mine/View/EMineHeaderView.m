//
//  EMineHeaderView.m
//  Easy
//
//  Created by yituiyun on 2017/11/30.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EMineHeaderView.h"
#import "EUserModel.h"

@implementation EMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapAction)];
        [self addGestureRecognizer:headerTap];
    }
    return self;
}

- (void)setupUI{
    
    /// icon
    UIView *imageContent = [[UIView alloc]init];
    imageContent.backgroundColor = [UIColor colorWithHexString:@"#fbe090"];
    [self addSubview:imageContent];
    imageContent.cornerRadius = E_RealHeight(85) / 2;
    [imageContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(E_RealWidth(24));
        make.width.height.mas_equalTo(E_RealHeight(85));
        make.centerY.mas_equalTo(self);
    }];
    
    
    self.imageView = [[UIImageView alloc]init];
    [imageContent addSubview:self.imageView];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.cornerRadius = E_RealHeight(75) / 2;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(E_RealHeight(75));
        make.center.mas_equalTo(imageContent);
    }];
    
    
    /// name
    self.nameLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(18)] textColor:[UIColor whiteColor] text:@"小灰灰" textAlignment:0];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(E_RealWidth(20));
        make.top.mas_equalTo(self).offset(E_RealHeight(38));
        make.width.mas_lessThanOrEqualTo(kScreenW * 0.2);
    }];
    
    self.sexImageView = [[UIImageView alloc]init];
    [self addSubview:self.sexImageView];
    [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.width.mas_equalTo(E_RealWidth(18));
        make.height.mas_equalTo(E_RealHeight(19));
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(E_RealWidth(27));
    }];
    
    self.ageLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor whiteColor] text:@"21" textAlignment:0];
    
    [self addSubview:self.ageLabel];
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.sexImageView);
        make.left.mas_equalTo(self.sexImageView.mas_right).offset(E_RealWidth(10));
    }];
    
    
    
    /// phone
    self.phoneLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor whiteColor] text:@"手机哈：13542720938" textAlignment:0];
    [self addSubview:self.phoneLabel];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(E_RealHeight(17));
    }];
    
    self.phoneLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneAction)];
    [self.phoneLabel addGestureRecognizer:phoneTap];
    
    self.arrowImageView = [[UIImageView alloc]init];
    self.arrowImageView.image = [UIImage imageNamed:@"bianjijiantou"];
    [self addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.phoneLabel);
        make.left.mas_equalTo(self.phoneLabel.mas_right).offset(E_RealWidth(5));
    }];
    
    
    
    /// 申请带队
    self.addGroupBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] normalColor:[UIColor colorWithHexString:@"#ffbf02"] selectColor:nil title:@"申请带队" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(addGroupAction)];
    [self.addGroupBtn setBackgroundColor:[UIColor whiteColor]];
    self.addGroupBtn.cornerRadius = 4;
    [self addSubview:self.addGroupBtn];
    [self.addGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(80), E_RealHeight(35)));
        make.right.mas_equalTo(self.mas_right).offset(-E_RealWidth(14));
        make.bottom.mas_equalTo(self.nameLabel);
    }];
    
    
}

- (void)setUserModel:(EUserModel *)userModel{
    _userModel = userModel;
    self.phoneLabel.text = [NSString stringWithFormat:@"手机号：%@",userModel.mobile];
//    self.ageLabel.text = [userModel.birthday timeIntervalToAge];
    self.ageLabel.text = userModel.age;
    self.nameLabel.text = userModel.name;
    NSString *sexImageName = [userModel.sex intValue] == 1 ? @"nan" : @"nv";
    self.sexImageView.image = [UIImage imageNamed:sexImageName];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:E_FullImagePath(userModel.avatar)] placeholderImage:E_PlaceholderImage];
    self.addGroupBtn.hidden = [userModel.type intValue] == 0 ? NO : YES;
}

#pragma mark - *** Actions
- (void)addGroupAction{
    if (self.addGroupBlock) {
        self.addGroupBlock();
    }
}

- (void)phoneAction{
    if (self.phoneBlock) {
        self.phoneBlock();
    }
}

- (void)headerTapAction{
    if (self.headerBlock) {
        self.headerBlock();
    }
}


@end
