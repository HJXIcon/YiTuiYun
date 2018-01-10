//
//  EStatisticalTableHeaderView.m
//  Easy
//
//  Created by yituiyun on 2017/12/14.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EStatisticalTableHeaderView.h"
CGFloat const EStatisticalTableHeaderViewHeight = 94;
#pragma mark - *** 工资筛选
@interface EStatisticalTableHeaderTopView : UIView

@property (nonatomic, strong) UILabel *wagesLabel;
@property (nonatomic, copy) void(^filterBlock)(void);
@property (nonatomic, strong) UILabel *peopleNumLabel;
@property (nonatomic, strong) UIButton *filterBtn;
@property (nonatomic, weak) UILabel *numMsgLabel;
@end

@implementation EStatisticalTableHeaderTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.filterBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] normalColor:[UIColor colorWithHexString:@"#565656"] selectColor:nil title:@"日期筛选" nornamlImageName:@"shaixuan" selectImageName:nil textAlignment:NSTextAlignmentRight target:self action:@selector(filterAction)];
    self.filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [self.filterBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.filterBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#f0e9d8"]] forState:UIControlStateHighlighted];
    [self addSubview:self.filterBtn];
    self.filterBtn.ba_padding = 7;
    self.filterBtn.ba_padding_inset = 10;
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.width.mas_equalTo(E_RealWidth(97));
        make.height.mas_equalTo(50);
    }];
    
    /// 工资
    UILabel *msgLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"#565656"] text:@"总工资:" textAlignment:0];
    [self addSubview:msgLabel];
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(E_RealWidth(10));
        make.centerY.mas_equalTo(self);
    }];
    
    self.wagesLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"ff4b4b"] text:@"0元" textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.wagesLabel];
    [self.wagesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(msgLabel);
        make.left.mas_equalTo(msgLabel.mas_right).offset(E_RealWidth(5));
    }];
    
    /// 人数
    UILabel *numMsgLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"#565656"] text:@"人数:" textAlignment:0];
    _numMsgLabel = numMsgLabel;
    [self addSubview:numMsgLabel];
    [numMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wagesLabel.mas_right).offset(E_RealWidth(34));
        make.centerY.mas_equalTo(self);
    }];
    
    self.peopleNumLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"ff4b4b"] text:@"88人" textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.peopleNumLabel];
    [self.peopleNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(msgLabel);
        make.left.mas_equalTo(numMsgLabel.mas_right).offset(E_RealWidth(5));
    }];
    
    
}

- (void)filterAction{
    if (self.filterBlock) {
        self.filterBlock();
    }
}

@end


#pragma mark - *** EStatisticalTableHeaderView
@interface EStatisticalTableHeaderView()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) EStatisticalTableHeaderTopView *headerView;

@end

@implementation EStatisticalTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupUI{
    JXWeak(self);
    self.headerView = [[EStatisticalTableHeaderTopView alloc]init];
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
    
    CGSize size = CGSizeMake(kScreenW / 5,44);
    UIColor *color = [UIColor colorWithHexString:@"#333333"];
    UIFont *font = [UIFont systemFontOfSize:E_FontRadio(14)];
    self.nameLabel = [JXFactoryTool creatLabel:CGRectZero font:font textColor:color text:@"姓名" textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(-5);
        make.size.mas_equalTo(size);
    }];
    
    
    self.startTimeLabel = [JXFactoryTool creatLabel:CGRectZero font:font textColor:color text:@"开始时间" textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.startTimeLabel];
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.size.mas_equalTo(size);
    }];
    
    self.endTimeLabel = [JXFactoryTool creatLabel:CGRectZero font:font textColor:color text:@"结束时间" textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.endTimeLabel];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.size.mas_equalTo(size);
    }];
    
    self.numLabel = [JXFactoryTool creatLabel:CGRectZero font:font textColor:color text:@"工时/\n房间号" textAlignment:NSTextAlignmentCenter];
    self.numLabel.numberOfLines = 2;
    [self addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.size.mas_equalTo(size);
    }];
    
    self.moneyLabel = [JXFactoryTool creatLabel:CGRectZero font:font textColor:color text:@"金额" textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.size.mas_equalTo(size);
    }];
    
    [self masonry_distributeSpacingHorizontallyWith:@[self.nameLabel,self.startTimeLabel,self.endTimeLabel,self.numLabel,self.moneyLabel]];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.left.right.mas_equalTo(self);
    }];
    
    
}

- (void)setPrice:(NSString *)price{
    _price = price;
    self.headerView.wagesLabel.text = [price floatValue] == 0 ? @"0元" : [NSString stringWithFormat:@"%.2f元",[price floatValue]];
}

- (void)setHiddenPeopleNumLabel:(BOOL)hiddenPeopleNumLabel{
    _hiddenPeopleNumLabel = hiddenPeopleNumLabel;
    self.headerView.peopleNumLabel.hidden = hiddenPeopleNumLabel;
    self.headerView.numMsgLabel.hidden = hiddenPeopleNumLabel;
}

- (void)setPeopleNum:(NSInteger)peopleNum{
    _peopleNum = peopleNum;
    self.headerView.peopleNumLabel.text = [NSString stringWithFormat:@"%ld人",peopleNum];
}
@end
