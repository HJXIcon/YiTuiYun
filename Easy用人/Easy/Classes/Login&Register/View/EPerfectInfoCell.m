//
//  EPerfectInfoCell.m
//  Easy
//
//  Created by yituiyun on 2017/11/21.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EPerfectInfoCell.h"

@implementation EPerfectInfoCell

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.leftLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(15)] textColor:[UIColor colorWithHexString:@"#565656"] text:@"姓名:" textAlignment:0];
    [self.contentView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(E_RealWidth(20));
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(E_RealWidth(70));
    }];
    
    
    self.rightLablel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:nil text:@"1993-04-21" textAlignment:0];
    [self.contentView addSubview:self.rightLablel];
    [self.rightLablel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftLabel.mas_right).offset(E_RealWidth(10));
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(E_RealHeight(44));
    }];
    self.rightLablel.hidden = YES;
    
    self.rightTextF = [[UITextField alloc]init];
    self.rightTextF.placeholder = @"请输入你的真实姓名";
    [self.rightTextF addTarget:self action:@selector(editingDidEndAction:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.rightTextF];
    [self.rightTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftLabel.mas_right).offset(E_RealWidth(10));
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(E_RealHeight(44));
    }];
    
    self.arrowImageView = [[UIImageView alloc]init];
    self.arrowImageView.image = [UIImage imageNamed:@"ziliao-jiantou"];
    [self.contentView addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-E_RealWidth(10));
        make.width.mas_equalTo(E_RealWidth(11));
        make.height.mas_equalTo(E_RealHeight(22));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
}

- (void)editingDidEndAction:(UITextField *)textF{
    if (self.rightTextFeildBlock) {
        self.rightTextFeildBlock(textF.text);
    }
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
