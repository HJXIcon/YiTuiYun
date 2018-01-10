//
//  EMyTeamCell.m
//  Easy
//
//  Created by yituiyun on 2017/12/18.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EMyTeamCell.h"
#import "EMyTeamListModel.h"


@interface EMyTeamCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;


@end
@implementation EMyTeamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.image = [UIImage imageNamed:@"touxiang"];
    self.iconImageView.cornerRadius = 15;
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    self.nameLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"464646"] text:@"小灰灰" textAlignment:0];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
    }];
    
    self.phoneLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"464646"] text:@"13800138000" textAlignment:0];
    [self.contentView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
    }];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"mine_gou"] forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"mine_goushang"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(22);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
    }];
}


- (void)setModel:(EMyTeamListModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:E_FullImagePath(model.childUserAvatar)] placeholderImage:E_PlaceholderImage];
    self.nameLabel.text = model.childUserName;
    self.phoneLabel.text = model.childUserMobile;
    self.selectBtn.selected = model.isSelect;
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
