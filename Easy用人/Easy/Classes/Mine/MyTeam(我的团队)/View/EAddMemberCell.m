//
//  EAddMemberCell.m
//  Easy
//
//  Created by yituiyun on 2017/12/18.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EAddMemberCell.h"
#import "EUserModel.h"

@interface EAddMemberCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation EAddMemberCell

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
    
    
    self.addBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:16] normalColor:nil selectColor:nil title:@"添加" nornamlImageName:nil selectImageName:nil textAlignment:0 target:self action:@selector(addAction)];
    [self.addBtn setBackgroundImage:[UIImage imageWithColor:EThemeColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.addBtn];
    self.addBtn.cornerRadius = 15;
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
    }];
}

- (void)addAction{
    if (self.addBlock) {
        self.addBlock();
    }
}

- (void)setModel:(EUserModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:E_FullImagePath(model.avatar)] placeholderImage:E_PlaceholderImage];
}
@end
