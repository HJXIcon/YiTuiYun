//
//  ENotiCenterTableCell.m
//  Easy
//
//  Created by yituiyun on 2017/12/4.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ENotiCenterTableCell.h"
#import "ENotiCenterModel.h"

@interface ENotiCenterTableCell ()
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation ENotiCenterTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    
    self.arrowImageView = [[UIImageView alloc]init];
    self.arrowImageView.image = [UIImage imageNamed:@"mine_jiantou"];
    [self.contentView addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(12.5), E_RealHeight(22)));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-E_RealWidth(10));
    }];
    
    
    self.desLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#565656"] text:@"下班还未打卡" textAlignment:0];
    [self.contentView addSubview:self.desLabel];
    self.desLabel.numberOfLines = 0;
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(E_RealWidth(10));
        make.top.mas_equalTo(E_RealHeight(13));
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-E_RealWidth(10));
    }];
    
    self.timeLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor colorWithHexString:@"#909090"] text:@"2017-11-24" textAlignment:0];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(E_RealWidth(15));
        make.top.mas_equalTo(self.desLabel.mas_bottom).offset(E_RealHeight(12));
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-E_RealWidth(10));
    }];
}

- (void)setModel:(ENotiCenterModel *)model{
    _model = model;
    self.desLabel.text = model.title;
    self.timeLabel.text = [model.addTime timeIntervalWithFormat:@"yyyy-MM-dd"];
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
