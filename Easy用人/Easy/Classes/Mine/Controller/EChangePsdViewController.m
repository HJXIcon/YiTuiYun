//
//  EChangePsdViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/1.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EChangePsdViewController.h"
#import "EUserModel.h"
#import "ELoginViewModel.h"

@interface EChangePsdViewController ()
@property (nonatomic, strong) UITextField *originPsdTextF;
@property (nonatomic, strong) UITextField *changePsdTextF;
@property (nonatomic, strong) UITextField *sureNewPsdTextF;
@property (nonatomic, strong) UIButton *sureBtn;
@end

@implementation EChangePsdViewController

- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [JXFactoryTool creatButton:CGRectMake(0, 44 * 4, E_RealWidth(300), E_RealHeight(50)) font:[UIFont systemFontOfSize:E_FontRadio(18)] normalColor:[UIColor whiteColor] selectColor:nil title:@"确定" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(sureAction:)];
        _sureBtn.centerX = self.view.centerX;
        UIImage *norImage = [UIImage imageGradientWithFrame:CGRectMake(0, 44 * 4, E_RealWidth(300), E_RealHeight(50)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
        _sureBtn.cornerRadius = E_RealHeight(25);
        [_sureBtn setBackgroundImage:norImage forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
        
    }
    return _sureBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    [self setupUI];
}

- (void)setupUI{
    
    /// 原密码
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.originPsdTextF = [[UITextField alloc]init];
    self.originPsdTextF.placeholder = @"为确保你的密码安全，请输入原密码";
    self.originPsdTextF.font = [UIFont systemFontOfSize:E_FontRadio(14)];
    self.originPsdTextF.backgroundColor = [UIColor whiteColor];
    self.originPsdTextF.cornerRadius = 5;
    self.originPsdTextF.leftView = leftView;
    self.originPsdTextF.leftViewMode = UITextFieldViewModeAlways;
    self.originPsdTextF.keyboardType = UIKeyboardTypeNamePhonePad;
    self.originPsdTextF.secureTextEntry = YES;
    [self.view addSubview:self.originPsdTextF];
    [self.originPsdTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(E_RealWidth(300), E_RealHeight(44)));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(E_RealHeight(42) + E_StatusBarAndNavigationBarHeight);
    }];
    
    UILabel *originLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#4d4d4d"] text:@"原密码:" textAlignment:0];
    [self.view addSubview:originLabel];
    [originLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.originPsdTextF.mas_top).offset(-E_RealHeight(6));
        make.left.mas_equalTo(self.originPsdTextF);
    }];
    
    
    /// 新密码
    UIView *leftView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.changePsdTextF = [[UITextField alloc]init];
    self.changePsdTextF.placeholder = @"请输入新密码";
    self.changePsdTextF.font = [UIFont systemFontOfSize:E_FontRadio(14)];
    self.changePsdTextF.backgroundColor = [UIColor whiteColor];
    self.changePsdTextF.cornerRadius = 5;
    self.changePsdTextF.leftView = leftView2;
    self.changePsdTextF.leftViewMode = UITextFieldViewModeAlways;
    self.changePsdTextF.keyboardType = UIKeyboardTypeNamePhonePad;
    self.changePsdTextF.secureTextEntry = YES;
    [self.view addSubview:self.changePsdTextF];
    [self.changePsdTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(E_RealWidth(300), E_RealHeight(44)));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.originPsdTextF.mas_bottom).offset(E_RealHeight(42));
    }];
    
    UILabel *changeLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#4d4d4d"] text:@"新密码:" textAlignment:0];
    [self.view addSubview:changeLabel];
    [changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.changePsdTextF.mas_top).offset(-E_RealHeight(6));
        make.left.mas_equalTo(self.changePsdTextF);
    }];
    
    
    
    /// 确定新密码
    UIView *leftView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.sureNewPsdTextF = [[UITextField alloc]init];
    self.sureNewPsdTextF.placeholder = @"请输入新密码";
    self.sureNewPsdTextF.font = [UIFont systemFontOfSize:E_FontRadio(14)];
    self.sureNewPsdTextF.backgroundColor = [UIColor whiteColor];
    self.sureNewPsdTextF.cornerRadius = 5;
    self.sureNewPsdTextF.leftView = leftView3;
    self.sureNewPsdTextF.leftViewMode = UITextFieldViewModeAlways;
    self.sureNewPsdTextF.keyboardType = UIKeyboardTypeNamePhonePad;
    self.sureNewPsdTextF.secureTextEntry = YES;
    [self.view addSubview:self.sureNewPsdTextF];
    [self.sureNewPsdTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(E_RealWidth(300), E_RealHeight(44)));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.changePsdTextF.mas_bottom).offset(E_RealHeight(42));
    }];
    
    UILabel *sureNewLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#4d4d4d"] text:@"确认新密码:" textAlignment:0];
    [self.view addSubview:sureNewLabel];
    [sureNewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.sureNewPsdTextF.mas_top).offset(-E_RealHeight(6));
        make.left.mas_equalTo(self.sureNewPsdTextF);
    }];
    
    /// 确定
    UILabel *sureLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#9a9a9a"] text:@"密码由6-20位英文字母、数字组成" textAlignment:0];
    [self.view addSubview:sureLabel];
    [sureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sureNewLabel);
        make.top.mas_equalTo(self.sureNewPsdTextF.mas_bottom).offset(E_RealHeight(19));
    }];
    
    [self.view addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(sureLabel.mas_bottom).offset(E_RealHeight(37));
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(300), E_RealHeight(50)));
    }];
    
}

#pragma mark - *** Actions
- (void)sureAction:(UIButton *)button{
    if (kStringIsEmpty(self.originPsdTextF.text)) {
        return [self showHint:@"请输入原密码"];
    }
    
    if (kStringIsEmpty(self.changePsdTextF.text)) {
        return [self showHint:@"请输入新密码"];
    }
    
    if (kStringIsEmpty(self.sureNewPsdTextF.text)) {
        return [self showHint:@"请再输入一次新密码"];
    }
    
    [ELoginViewModel EditPasswordWithUserId:[EUserInfoManager getUserInfo].userId oldPsd:self.originPsdTextF.text newPsd:self.changePsdTextF.text rePassword:self.sureNewPsdTextF.text];
    
}
@end
