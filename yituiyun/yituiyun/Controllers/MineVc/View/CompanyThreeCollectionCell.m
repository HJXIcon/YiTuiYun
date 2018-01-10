//
//  CompanyThreeCollectionCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CompanyThreeCollectionCell.h"

@implementation CompanyThreeCollectionCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
-(instancetype)init{
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
//    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:FontRadio(14)];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.contentLabel];
}

-(void)setDict:(NSDictionary *)dict{
    
    
}

-(void)setModel:(CompanyNeedModel *)model{
    _model = model;
    
    self.contentLabel.text = model.name_zh;
    CGSize size = CGSizeMake(1000, 1000);
    NSMutableDictionary *parmdict = @{NSFontAttributeName:[UIFont systemFontOfSize:FontRadio(14)]};
    CGSize titleSize =   [model.name_zh boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:parmdict context:nil].size;
    
    self.contentLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentLabel.layer.borderWidth = 1;
    self.contentLabel.layer.cornerRadius = (titleSize.height+10)*0.5;
    self.contentLabel.clipsToBounds = YES;
    
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.contentView.mas_centerX);
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
//        make.width.mas_equalTo(@(titleSize.width+15));
//        make.height.mas_equalTo(@(titleSize.height+10));
//    }];
    self.contentLabel.frame = CGRectMake(10, 10, titleSize.width+15, titleSize.height+10);
   

}

@end
