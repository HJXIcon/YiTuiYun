//
//  EHomeViewController+NotScan.m
//  Easy
//
//  Created by yituiyun on 2017/11/24.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EHomeViewController+NotScan.h"
#import "EScanViewController.h"
#import "EWebViewController.h"
#import "ENavigationController.h"

@interface EHomeViewController()

@end

@implementation EHomeViewController (NotScan)

- (void)jx_showNotScanView{
    
    self.navigationItem.title = @"扫码";
    
    UIView *bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"chatu"];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.width.height.mas_equalTo(E_RealWidth(95.0));
        make.top.mas_equalTo(bgView).offset(E_RealHeight(125) + E_StatusBarAndNavigationBarHeight);
    }];
    
    
    UILabel *label = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"0x707070"] text:@"请通过扫二维码获取信息" textAlignment:NSTextAlignmentCenter];
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView);
        make.top.mas_equalTo(imageView.mas_bottom).offset(E_RealHeight(20));
    }];
    
    
    UIButton *scanBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_PSFontRadio(36)] normalColor:[UIColor whiteColor] selectColor:nil title:@"扫一扫" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(scanAction)];
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"kongjian"] forState:UIControlStateNormal];
    scanBtn.adjustsImageWhenHighlighted = NO;
    [bgView addSubview:scanBtn];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView);
        make.width.mas_equalTo(E_RealWidth(300));
        make.height.mas_equalTo(E_RealHeight(50));
        make.top.mas_equalTo(label.mas_bottom).offset(E_RealHeight(32));
    }];
    
    
}

- (void)scanAction{
    
    EScanViewController *vc = [[EScanViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
