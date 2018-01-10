//
//  CompanyLabelCell.m
//  yituiyun
//
//  Created by yituiyun on 2017/6/15.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "CompanyLabelCell.h"

@implementation CompanyLabelCell
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
    
    self.panView = [[UIView alloc]init];
    self.panView.backgroundColor = [UIColor whiteColor];
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:FontRadio(14)];
    self.contentLabel.textColor = [UIColor blackColor];
    self.showView = [[UIView alloc]init];
    self.showView.backgroundColor = UIColorFromRGBString(@"0xdfdfdf");
    self.showView.layer.cornerRadius = 7.5;
    self.showView.clipsToBounds = YES;
    [self.contentView addSubview:self.panView];
    [self.panView addSubview:self.contentLabel];
    [self.panView addSubview:self.showView];
}

-(void)setModel:(CompanyNeedModel *)model{
    _model = model;
    
    
    self.contentLabel.text = model.name_zh;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    NSMutableDictionary *parmdict = @{NSFontAttributeName:[UIFont systemFontOfSize:FontRadio(14)]};
    CGSize titleSize =   [model.name_zh boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parmdict context:nil].size;
//    CGSize titleSize = [self.contentLabel sizeThatFits:size];
    
    CGFloat w = titleSize.width;  CGFloat h = titleSize.height;
    
   
    
    CGFloat panViewW = w +15 +20;
   
    CGFloat panViewH = h+10;
    //panview
    
    
    self.panView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.panView.layer.cornerRadius = panViewH*0.5;
    self.panView.layer.borderWidth = 1;
    self.panView.clipsToBounds = YES;

//    [self.panView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
//        make.left.mas_equalTo(self.contentView.mas_left);
//        make.width.mas_equalTo(@(panViewW));
//        make.height.mas_equalTo(@(panViewH));
//    }];
    self.panView.frame = CGRectMake(10, 0, panViewW, panViewH);
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.panView.mas_centerY);
        make.left.mas_equalTo(self.panView.mas_left).offset(7);
//        make.width.mas_equalTo(@(w));
//        
//        make.height.mas_equalTo(@(h));
        
        
    }];
    
    
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.panView.mas_centerY);
        make.left.mas_equalTo(self.contentLabel.mas_right).offset(5);
        make.width.mas_equalTo(@(15));
        make.height.mas_equalTo(@(15));
    }];
    
    
    
    

}

-(void)setBackToShowViewNormal{
    self.showView.backgroundColor = UIColorFromRGBString(@"0xdfdfdf");
}

-(void)setBackToShowViewSelect{
       self.showView.backgroundColor = [UIColor redColor];
}


@end
