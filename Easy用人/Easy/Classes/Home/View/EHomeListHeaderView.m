//
//  EHomeListHeaderFooterView.m
//  Easy
//
//  Created by yituiyun on 2017/11/27.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EHomeListHeaderView.h"
#import "EHomeListWagesHeaderView.h"

CGFloat const EHomeListHeaderViewHeight = 94;

@interface EHomeListHeaderView ()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) EHomeListWagesHeaderView *headerView;
@end

@implementation EHomeListHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupUI{
    JXWeak(self);
    self.headerView = [[EHomeListWagesHeaderView alloc]init];
    self.headerView.filterBlock = ^{
        if (weakself.filterBlock) {
            weakself.filterBlock();
        }
    };
    [self addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    CGSize size = CGSizeMake(kScreenW / 5, EHomeListHeaderViewHeight);
    UIColor *color = [UIColor colorWithHexString:@"#333333"];
    UIFont *font = [UIFont systemFontOfSize:E_FontRadio(14)];
    self.dayLabel = [JXFactoryTool creatLabel:CGRectZero font:font textColor:color text:@"日期" textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.dayLabel];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset((44-size.height) * 0.5);
        make.size.mas_equalTo(size);
    }];
    
    
    self.timeLabel = [JXFactoryTool creatLabel:CGRectZero font:font textColor:color text:@"起止时间" textAlignment:NSTextAlignmentCenter];
    self.timeLabel.numberOfLines = 2;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.dayLabel);
        make.size.mas_equalTo(size);
    }];
    
    self.numLabel = [JXFactoryTool creatLabel:CGRectZero font:font textColor:color text:@"工时/\n房间号" textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.numLabel];
    self.numLabel.numberOfLines = 2;
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.dayLabel);
        make.size.mas_equalTo(size);
    }];
    
    self.moneyLabel = [JXFactoryTool creatLabel:CGRectZero font:font textColor:color text:@"金额" textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.dayLabel);
        make.size.mas_equalTo(size);
    }];
    
    self.jobLabel = [JXFactoryTool creatLabel:CGRectZero font:font textColor:color text:@"职位" textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.jobLabel];
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.dayLabel);
        make.size.mas_equalTo(size);
    }];
    
    [self masonry_distributeSpacingHorizontallyWith:@[self.dayLabel,self.timeLabel,self.numLabel,self.moneyLabel,self.jobLabel]];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.left.right.mas_equalTo(self);
    }];
}

- (void)setPrice:(CGFloat)price{
    _price = price;

    self.headerView.wagesLabel.text = price == 0 ? @"0元" : [NSString stringWithFormat:@"%.2f元",price];
}

@end
