//
//  JXPunchClockHeaderView.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/9/14.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXPunchClockHeaderView.h"
#import "LHKNodeButton.h"

@interface JXPunchClockHeaderView ()
@property (nonatomic, strong) LHKNodeButton *firstBtn;
@property (nonatomic, strong) UIButton *arrowBtn1;
@property (nonatomic, strong) LHKNodeButton *middleBtn;
@property (nonatomic, strong) UIButton *arrowBtn2;
@property (nonatomic, strong) LHKNodeButton *lastBtn;

@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *lastLabel;


@end
@implementation JXPunchClockHeaderView

#pragma mark - setter
- (void)setCheckInTime:(NSString *)checkInTime{
    _checkInTime = checkInTime;
    if ([ZQ_CommonTool isEmpty:checkInTime]) {
        self.firstLabel.hidden = YES;
    }else{
        self.firstLabel.hidden = NO;
    }
    
     self.firstLabel.text = checkInTime;
}


- (void)setCheckOutTime:(NSString *)checkOutTime{
    _checkOutTime = checkOutTime;
    
    if ([ZQ_CommonTool isEmpty:checkOutTime]) {
        self.middleLabel.hidden = YES;
    }else{
        self.middleLabel.hidden = NO;
    }
    self.middleLabel.text = checkOutTime;
}

- (void)setGetPaidTime:(NSString *)getPaidTime{
    _getPaidTime = getPaidTime;
    
    if ([ZQ_CommonTool isEmpty:getPaidTime]) {
        self.lastLabel.hidden = YES;
    }else{
         self.lastLabel.hidden = NO;
    }
    self.lastLabel.text = getPaidTime;
}


- (void)setStep:(JXPunchClockHeaderViewStep)step{
    
    switch (step) {
            
        case JXPunchClockHeaderViewStepNotCheck:
            self.desLabel.text = @"还未打上班卡，请打卡！";
            break;
            
        case JXPunchClockHeaderViewStepCheckIn:
        {
            self.firstBtn.selected = YES;
            self.arrowBtn1.selected = YES;
            self.desLabel.text = @"还未打下班卡，请打卡！";
        }
            break;
            
            
        case JXPunchClockHeaderViewStepCheckOut:
        {
            self.firstBtn.selected = YES;
            self.arrowBtn1.selected = YES;
            self.middleBtn.selected = YES;
            self.arrowBtn2.selected = YES;
            self.desLabel.text = @"正在审核中，请耐心等待！";
            
            
        }
            
            break;
            
            
        case JXPunchClockHeaderViewStepGetPaid:
        {
            self.firstBtn.selected = YES;
            self.arrowBtn1.selected = YES;
            self.middleBtn.selected = YES;
            self.arrowBtn2.selected = YES;
            self.lastBtn.selected = YES;
            self.desLabel.text = @"审核已通过！";
        }
            break;
            
        default:
            break;
    }
}



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.firstBtn = [self setupOneNodeBtnWithNorImageName:@"shangbandaka-" selImageName:@"shangbandaka" norTitle:@"上班打卡"];
    self.middleBtn = [self setupOneNodeBtnWithNorImageName:@"xiabandaka" selImageName:@"xiabandaka-" norTitle:@"下班打卡"];
    self.lastBtn = [self setupOneNodeBtnWithNorImageName:@"tasknode3_no" selImageName:@"tasknode3_yes" norTitle:@"获得工资"];
    self.arrowBtn1 = [self setupOneBtnWithNorImageName:@"nodejiantou_no" selImageName:@"nodejiantou_yes"];
    self.arrowBtn2 = [self setupOneBtnWithNorImageName:@"nodejiantou_no" selImageName:@"nodejiantou_yes"];
    
    self.firstLabel = [self setupOneLabel];
    self.middleLabel = [self setupOneLabel];
    self.lastLabel = [self setupOneLabel];
    self.firstLabel.hidden = YES;
    self.middleLabel.hidden = YES;
    self.lastLabel.hidden = YES;
    
    self.desLabel = [self setupOneLabel];
    self.desLabel.text = @"还未打下班卡，请打卡！";
    self.desLabel.font = [UIFont systemFontOfSize:13];
    
    
    [self addSubview:self.firstBtn];
    [self addSubview:self.middleBtn];
    [self addSubview:self.lastBtn];
    [self addSubview:self.arrowBtn1];
    [self addSubview:self.arrowBtn2];
    
    [self addSubview:self.firstLabel];
    [self addSubview:self.middleLabel];
    [self addSubview:self.lastLabel];
    
    [self addSubview:self.desLabel];
    
    
    CGFloat btnW = ScreenWidth / 5.0;
    
    // 布局
    [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@[self.middleBtn,self.arrowBtn1,self.arrowBtn2,self.lastBtn]);
        make.size.mas_equalTo(CGSizeMake(btnW, 90));
    }];
    
    [self.middleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnW, 90));
        make.height.mas_equalTo(90);
    }];
    
    [self.lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnW, 90));
        
    }];
    
    
    [self distributeSpacingHorizontallyWith:@[self.firstBtn,self.arrowBtn1,self.middleBtn,self.arrowBtn2,self.lastBtn]];
    
    
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.firstBtn.mas_centerX).offset(5);
        make.top.mas_equalTo(self.firstBtn.mas_bottom).offset(5);
    }];
    
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.middleBtn.mas_centerX);
        make.top.mas_equalTo(self.middleBtn.mas_bottom).offset(5);
        
    }];
    
    [self.lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.lastBtn.mas_centerX);
        make.top.mas_equalTo(self.lastBtn.mas_bottom).offset(5);
    }];
    
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.middleBtn.mas_centerX);
        make.top.mas_equalTo(self.firstLabel.mas_bottom).offset(5);
    }];

}


/// 等间距水平布局
- (void) distributeSpacingHorizontallyWith:(NSArray*)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    UIView *v0 = spaces[0];
    
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(((UIView*)views[0]).mas_centerY);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastSpace.mas_right);
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj.mas_right);
            make.centerY.equalTo(obj.mas_centerY);
            make.width.equalTo(v0);
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
    }];
    
}



- (instancetype)setupOneLabel{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:FontRadio(10)];
    
    label.text = @"2017-09-14 16:16";
    return label;
}

/// 创建一个系统button
- (instancetype)setupOneBtnWithNorImageName:(NSString *)norImageName
                               selImageName:(NSString *)selImageName{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:norImageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
    btn.userInteractionEnabled = NO;
    return btn;
    
}


/// 创建一个自定义button
- (instancetype)setupOneNodeBtnWithNorImageName:(NSString *)norImageName
               selImageName:(NSString *)selImageName
                   norTitle:(NSString *)norTitle{
    LHKNodeButton *btn = [LHKNodeButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:norImageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:11];
    [btn setTitle:norTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    btn.userInteractionEnabled = NO;
    return btn;
}


@end
