//
//  EPerfectInfoSexCell.m
//  Easy
//
//  Created by yituiyun on 2017/11/21.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EPerfectInfoSexCell.h"

@interface EPerfectInfoSexCell()
@property (nonatomic, strong) UIButton *maleBtn;
@property (nonatomic, strong) UIButton *femaleBtn;

@end
@implementation EPerfectInfoSexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)setupUI{
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.image = [UIImage imageNamed:@"touxiang"];
    [self.contentView addSubview:self.iconImageView];
    self.iconImageView.userInteractionEnabled = YES;
    self.iconImageView.cornerRadius = E_RealWidth(40);
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(E_RealWidth(80));
        make.top.mas_equalTo(E_RealHeight(28));
        make.centerX.mas_equalTo(self.contentView);
    }];
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTapAction)];
    [self.iconImageView addGestureRecognizer:iconTap];
    
    self.maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.maleBtn addTarget:self action:@selector(maleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.maleBtn setBackgroundImage:[UIImage imageNamed:@"meigou"] forState:UIControlStateNormal];
    [self.maleBtn setBackgroundImage:[UIImage imageNamed:@"gou"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.maleBtn];
    self.maleBtn.selected = YES;
    self.maleBtn.adjustsImageWhenHighlighted = NO;
    [self.maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(E_RealWidth(20));
        make.left.mas_equalTo(self.contentView).offset(E_RealWidth(108));
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(E_RealHeight(31));
    }];
    
    UILabel *maleLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#565656"] text:@"男" textAlignment:0];
    [self.contentView addSubview:maleLabel];
    [maleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.maleBtn);
        make.left.mas_equalTo(self.maleBtn.mas_right).offset(E_RealWidth(15));
    }];
    
    
    /// 女
    UILabel *femaleLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#565656"] text:@"女" textAlignment:0];
    [self.contentView addSubview:femaleLabel];
    [femaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.maleBtn);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-E_RealWidth(108));
    }];
    
    self.femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.femaleBtn.adjustsImageWhenHighlighted = NO;
    [self.femaleBtn addTarget:self action:@selector(femaleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.femaleBtn setBackgroundImage:[UIImage imageNamed:@"meigou"] forState:UIControlStateNormal];
    [self.femaleBtn setBackgroundImage:[UIImage imageNamed:@"gou"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.femaleBtn];
    [self.femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(E_RealWidth(20));
        make.centerY.mas_equalTo(self.maleBtn);
        make.right.mas_equalTo(femaleLabel.mas_left).offset(-E_RealWidth(15));
    }];
    
    
}

- (void)setSex:(NSString *)sex{
    _sex = sex;
    self.femaleBtn.selected = [sex intValue] == 0;
    self.maleBtn.selected = [sex intValue] == 1;
}

- (void)femaleAction:(UIButton *)button{
    self.femaleBtn.selected = YES;
    self.maleBtn.selected = NO;
    self.sex = @"0";
    
    if (self.sexBlock) {
        self.sexBlock(self.sex);
    }
}

- (void)maleAction:(UIButton *)button{
    self.femaleBtn.selected = NO;
    self.maleBtn.selected = YES;
    self.sex = @"1";
    
    if (self.sexBlock) {
        self.sexBlock(self.sex);
    }
}

- (void)iconTapAction{
    if (self.iconTapBlock) {
        self.iconTapBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (CGFloat)cellHeight{
    return E_RealHeight(187);
}
@end
