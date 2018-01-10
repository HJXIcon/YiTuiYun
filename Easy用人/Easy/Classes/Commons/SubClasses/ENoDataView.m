//
//  ENoDataView.m
//  Easy
//
//  Created by yituiyun on 2017/12/15.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ENoDataView.h"

@implementation ENoDataView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = EBackgroundColor;
    }
    return self;
}

- (void)setupUI{
    
    UILabel *hubLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#565656"] text:@"什么都没有哦!" textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:hubLabel];
    [hubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    UIImageView *iconImageV = [[UIImageView alloc]init];
    iconImageV.image = [UIImage imageNamed:@"meishuju"];
    [self addSubview:iconImageV];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(hubLabel.mas_top).offset(-18);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(95), E_RealWidth(95)));
    }];
    
    
    
}
@end
