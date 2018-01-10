//
//  EHomeListWagesCell.m
//  Easy
//
//  Created by yituiyun on 2017/11/24.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EHomeListWagesHeaderView.h"


@interface EHomeListWagesHeaderView()
@property (nonatomic, strong) UIButton *filterBtn;
@end

@implementation EHomeListWagesHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    
    self.filterBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] normalColor:[UIColor colorWithHexString:@"#565656"] selectColor:nil title:@"日期筛选" nornamlImageName:@"shaixuan" selectImageName:nil textAlignment:NSTextAlignmentRight target:self action:@selector(filterAction)];
    
    [self.filterBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.filterBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#f0e9d8"]] forState:UIControlStateHighlighted];
    [self addSubview:self.filterBtn];
    self.filterBtn.ba_padding = 7;
    self.filterBtn.ba_padding_inset = 10;
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.width.mas_equalTo(97);
        make.height.mas_equalTo(50);
    }];
   
    
    UILabel *msgLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"#565656"] text:@"总工资:" textAlignment:0];
    [self addSubview:msgLabel];
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.centerY.mas_equalTo(self);
    }];
    
    self.wagesLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"ff4b4b"] text:@"0元" textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.wagesLabel];
    [self.wagesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.centerY.mas_equalTo(msgLabel);
        make.left.mas_equalTo(msgLabel.mas_right).offset(5);
    }];
    
}

- (void)filterAction{
    if (self.filterBlock) {
        self.filterBlock();
    }
}


@end
