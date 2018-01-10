//
//  EPartManagerViewController+NoData.m
//  Easy
//
//  Created by yituiyun on 2017/12/11.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EPartManagerViewController+NoData.h"

#define NODataTag 998
@implementation EPartManagerViewController (NoData)

- (void)jx_showNoDataView{
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = EBackgroundColor;
    bgView.tag = NODataTag;
    [self.view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"chatu"];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.height.mas_equalTo(E_RealWidth(95.0));
        make.top.mas_equalTo(self.view).offset(E_RealHeight(140) + E_StatusBarAndNavigationBarHeight);
    }];
    
    
    UILabel *label = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"0x707070"] text:@"请与人力公司联系获取兼职列表哦~" textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView);
        make.top.mas_equalTo(imageView.mas_bottom).offset(E_RealHeight(25));
    }];
    
}

- (void)jx_removeNoDataView{
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == NODataTag) {
            [obj removeFromSuperview];
        }
    }];
}
@end
