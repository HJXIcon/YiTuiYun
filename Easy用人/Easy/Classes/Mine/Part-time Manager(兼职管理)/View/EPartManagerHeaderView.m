//
//  EPartManagerHeaderView.m
//  Easy
//
//  Created by yituiyun on 2017/12/11.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EPartManagerHeaderView.h"

@implementation EPartManagerHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setupUI{
    
    UILabel *allLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#434343"] text:@"全部" textAlignment:0];
    [self.contentView addSubview:allLabel];
    [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(E_RealWidth(10));
    }];
    
    
    UIButton *btn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] normalColor:[UIColor colorWithHexString:@"#ffbf00"] selectColor:nil title:@"统计表" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(btnAction)];
    btn.cornerRadius = 5;
    btn.borderWidth = 1;
    btn.borderColor = [UIColor colorWithHexString:@"#ffbf00"].CGColor;
    [btn setBackgroundImage:[UIImage imageWithColor:EThemeColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(70), E_RealHeight(30)));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-E_RealWidth(10));
    }];
}


- (void)btnAction{
    if (self.headerBlock) {
        self.headerBlock();
    }
}

@end
