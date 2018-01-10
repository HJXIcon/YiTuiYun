//
//  EDocumentCenterImageCell.m
//  Easy
//
//  Created by yituiyun on 2017/12/4.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EDocumentCenterImageCell.h"

@implementation EDocumentCenterImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.label = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor colorWithHexString:@"#565656"] text:@"" textAlignment:NSTextAlignmentCenter];
    CGFloat labelH = ceil([NSString sizeWithString:@"得失" andFont:[UIFont systemFontOfSize:E_FontRadio(14)] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height);
    
    self.label.numberOfLines = 2;
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(labelH * 2);
        make.top.mas_equalTo(E_RealHeight(18));
    }];
    
    
    self.imgView = [[UIImageView alloc]init];
    self.imgView.userInteractionEnabled = YES;
    self.imgView.image = [UIImage imageNamed:@"document_xiangji"];
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(125), E_RealWidth(125)));
        make.top.mas_equalTo(self.label.mas_bottom).offset(E_RealHeight(14));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.imgView addGestureRecognizer:tap];
}

- (void)tap{
    if (self.clickImageBlock) {
        self.clickImageBlock();
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
