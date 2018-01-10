//
//  EBindPhoneViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/1.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBindPhoneViewController.h"
#import "EValidatePhoneViewController.h"
#import "EUserModel.h"

@interface EBindPhoneViewController ()
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *changePhoneBtn;
@end

@implementation EBindPhoneViewController

#pragma mark - *** lazy load
- (UIButton *)changePhoneBtn{
    if (_changePhoneBtn == nil) {
        _changePhoneBtn = [JXFactoryTool creatButton:CGRectMake(0, 44 * 4, E_RealWidth(300), E_RealHeight(50)) font:[UIFont systemFontOfSize:E_FontRadio(18)] normalColor:[UIColor whiteColor] selectColor:nil title:@"更改手机号" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(changePhoneAction:)];
        _changePhoneBtn.centerX = self.view.centerX;
        UIImage *norImage = [UIImage imageGradientWithFrame:CGRectMake(0, 44 * 4, E_RealWidth(300), E_RealHeight(50)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
        _changePhoneBtn.cornerRadius = E_RealHeight(25);
        [_changePhoneBtn setBackgroundImage:norImage forState:UIControlStateNormal];
        [_changePhoneBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
        
    }
    return _changePhoneBtn;
}
- (UILabel *)phoneLabel{
    if (_phoneLabel == nil) {
        _phoneLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(18)] textColor:[UIColor colorWithHexString:@"#282828"] text:[NSString stringWithFormat:@"绑定的手机号:%@",[EUserInfoManager getUserInfo].mobile] textAlignment:NSTextAlignmentCenter];
    }
    return _phoneLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"绑定手机号";
    [self setupUI];
    
}

- (void)setupUI{
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(E_StatusBarAndNavigationBarHeight);
        make.height.mas_equalTo(E_RealHeight(227));
    }];
    
    
    UIImageView *phoneImageView = [[UIImageView alloc]init];
    phoneImageView.image = [UIImage imageNamed:@"shoujihao"];
    [bgView addSubview:phoneImageView];
    [phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(E_RealWidth(157));
        make.top.mas_equalTo(bgView).offset(E_RealHeight(34));
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(96), E_RealHeight(100)));
    }];
    
    [bgView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.top.mas_equalTo(phoneImageView.mas_bottom).offset(E_RealHeight(41));
    }];
    
    
    [self.view addSubview:self.changePhoneBtn];
    [self.changePhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(300), E_RealHeight(50)));
        make.top.mas_equalTo(bgView.mas_bottom).offset(E_RealHeight(49));
    }];
}


#pragma mark - *** Actions
- (void)changePhoneAction:(UIButton *)button{
    [self.navigationController pushViewController:[[EValidatePhoneViewController alloc]init] animated:YES];
}
@end
