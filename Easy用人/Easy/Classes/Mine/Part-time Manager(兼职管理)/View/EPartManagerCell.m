//
//  EPartManagerCell.m
//  Easy
//
//  Created by yituiyun on 2017/12/11.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EPartManagerCell.h"
#import "EPartManagerModel.h"

@interface EPartManagerCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UIButton *signBtn;

@end
@implementation EPartManagerCell

- (void)setFrame:(CGRect)frame{
    frame.origin.y += E_RealHeight(10);
    frame.size.height -= E_RealHeight(10);
    [super setFrame:frame];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.nameLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#434343"] text:@"长隆酒店" textAlignment:0];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(E_RealWidth(10));
        make.top.mas_equalTo(E_RealHeight(15));
        make.width.mas_lessThanOrEqualTo(kScreenW * 0.5);
    }];
    
    self.jobLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor colorWithHexString:@"#545353"] text:@"服务员" textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.jobLabel];
    self.jobLabel.cornerRadius = E_RealHeight(25 * 0.5);
    self.jobLabel.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(E_RealWidth(15));
        make.top.mas_equalTo(E_RealHeight(10));
        make.width.mas_equalTo(E_RealWidth(62));
        make.height.mas_equalTo(E_RealHeight(25));
    }];
    
    self.priceLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#ff3e3e"] text:@"10元/小时" textAlignment:0];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-E_RealWidth(10));
        make.centerY.mas_equalTo(self.jobLabel);
    }];
    
    self.timeLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor colorWithHexString:@"#646464"] text:@"2017-12-08  09:00-18:00" textAlignment:0];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(E_RealHeight(24));
    }];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(E_RealHeight(15));
    }];
    
    
    self.companyLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor colorWithHexString:@"#414040"] text:@"人力资源有限公司" textAlignment:0];
    [self.contentView addSubview:self.companyLabel];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(line.mas_bottom).offset(E_RealHeight(15));
    }];
    
    
    self.signBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] normalColor:[UIColor whiteColor] selectColor:nil title:@"报名表" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(signAction)];
    UIImage *norImage = [UIImage imageGradientWithFrame:CGRectMake(0, 44 * 4, E_RealWidth(300), E_RealHeight(100)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
    [self.signBtn setBackgroundImage:norImage forState:UIControlStateNormal];
    [self.signBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
    self.signBtn.cornerRadius = 5;
    [self.contentView addSubview:self.signBtn];
    [self.signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(7);
        make.right.mas_equalTo(self.priceLabel);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(70), E_RealHeight(30)));
    }];
}

- (void)signAction{
    if (self.signBlock) {
        self.signBlock();
    }
}

- (void)setModel:(EPartManagerModel *)model{
    _model = model;
    self.nameLabel.text = model.hotelName;
    self.jobLabel.text = model.jobTypeName;
    self.companyLabel.text = model.hrName;
    NSString *ymd = [model.startTime timeIntervalWithFormat:@"yyyy-MM-dd"];
    NSString *startHm = [model.startTime timeIntervalWithFormat:@"hh:mm"];
    NSString *endHm = [model.endTime timeIntervalWithFormat:@"hh:mm"];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@-%@",ymd,startHm,endHm];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元/小时",model.price];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
