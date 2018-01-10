//
//  EDocumentCenterTwoImageCell.m
//  Easy
//
//  Created by yituiyun on 2017/12/4.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EDocumentCenterTwoImageCell.h"

@implementation EDocumentCenterTwoImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.leftLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor colorWithHexString:@"#565656"] text:@"" textAlignment:NSTextAlignmentCenter];
    CGFloat labelH = ceil([NSString sizeWithString:@"得失" andFont:[UIFont systemFontOfSize:E_FontRadio(14)] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height);
    
    self.leftLabel.numberOfLines = 2;
    [self.contentView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(E_RealWidth(55 * 0.5));
        make.height.mas_equalTo(labelH * 2);
        make.top.mas_equalTo(E_RealHeight(18));
        make.width.mas_equalTo(E_RealWidth(125));
    }];
    
    self.leftImgView = [[UIImageView alloc]init];
    self.leftImgView.userInteractionEnabled = YES;
    self.leftImgView.image = [UIImage imageNamed:@"document_xiangji"];
    [self.contentView addSubview:self.leftImgView];
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(E_RealWidth(55 * 0.5));
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(125), E_RealWidth(125)));
        make.top.mas_equalTo(self.leftLabel.mas_bottom).offset(E_RealHeight(14));
    }];
    
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapAction)];
    [self.leftImgView addGestureRecognizer:leftTap];
    
    
    
    self.rightImgView = [[UIImageView alloc]init];
    self.rightImgView.userInteractionEnabled = YES;
    self.rightImgView.image = [UIImage imageNamed:@"document_xiangji"];
    [self.contentView addSubview:self.rightImgView];
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-E_RealWidth(55 * 0.5));
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(125), E_RealWidth(125)));
        make.top.mas_equalTo(self.leftImgView);
    }];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapAction)];
    [self.rightImgView addGestureRecognizer:rightTap];
    
    
    self.rightLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor colorWithHexString:@"#565656"] text:@"" textAlignment:NSTextAlignmentCenter];
    self.rightLabel.numberOfLines = 2;
    [self.contentView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftLabel);
        make.height.mas_equalTo(labelH * 2);
        make.centerX.mas_equalTo(self.rightImgView);
        make.width.mas_equalTo(E_RealWidth(125));
    }];
    
    
   
}

- (void)leftTapAction{
    if (self.clickLeftImgBlock) {
        self.clickLeftImgBlock();
    }
}

- (void)rightTapAction{
    if (self.clickRightImgBlock) {
        self.clickRightImgBlock();
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
