//
//  EValidatePhoneViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/1.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EValidatePhoneViewController.h"
#import "EValidateCodeViewController.h"
#import "EUserModel.h"
#import "ELoginViewModel.h"

@interface EValidatePhoneViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UIButton *nextBtn;
@end

@implementation EValidatePhoneViewController
#pragma mark - *** lazy load
- (UIButton *)nextBtn{
    if (_nextBtn == nil) {
        _nextBtn = [JXFactoryTool creatButton:CGRectMake(0, 44 * 4, E_RealWidth(300), E_RealHeight(50)) font:[UIFont systemFontOfSize:E_FontRadio(18)] normalColor:[UIColor whiteColor] selectColor:nil title:@"下一步" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(nextAction)];
        _nextBtn.centerX = self.view.centerX;
        UIImage *norImage = [UIImage imageGradientWithFrame:CGRectMake(0, 44 * 4, E_RealWidth(300), E_RealHeight(50)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
        _nextBtn.cornerRadius = E_RealHeight(25);
        [_nextBtn setBackgroundImage:norImage forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
        
    }
    return _nextBtn;
}

- (UITextField *)phoneTextF{
    if (_phoneTextF == nil) {
        _phoneTextF = [[UITextField alloc]init];
        _phoneTextF.placeholder = @"你本人的手机号";
        _phoneTextF.font = [UIFont systemFontOfSize:E_FontRadio(16)];
        _phoneTextF.delegate = self;
    }
    return _phoneTextF;
}

- (UILabel *)hintLabel{
    if (_hintLabel == nil) {
        
        _hintLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_RealWidth(16)] textColor:[UIColor colorWithHexString:@"#282828"] text:[NSString stringWithFormat:@"更换手机号后，下次登录可使用新手机号登录。当前手机号:%@",[EUserInfoManager getUserInfo].mobile] textAlignment:0];
        _hintLabel.numberOfLines = 0;
    }
    return _hintLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"验证手机号";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI{
    [self.view addSubview:self.hintLabel];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(E_RealHeight(13) + E_StatusBarAndNavigationBarHeight);
        make.left.mas_equalTo(E_RealWidth(10));
        make.right.mas_equalTo(self.view.mas_right).offset(-E_RealWidth(10));
    }];
    
    
    [self.view addSubview:self.phoneTextF];
    [self.phoneTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hintLabel.mas_bottom).offset(E_RealHeight(36));
        make.left.mas_equalTo(E_RealWidth(109));
        make.width.mas_equalTo(E_RealWidth(250));
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"#a1a1a1"];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneTextF.mas_bottom).offset(5);
        make.left.mas_equalTo(self.phoneTextF);
        make.width.mas_equalTo(E_RealWidth(250));
        make.height.mas_equalTo(1);
    }];
    
    UILabel *label = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(18)] textColor:[UIColor colorWithHexString:@"#282828"] text:@"+86" textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.phoneTextF);
        make.right.mas_equalTo(self.phoneTextF.mas_left).offset(-E_RealWidth(23));
        make.width.mas_equalTo(E_RealWidth(50));
    }];
    
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = [UIColor colorWithHexString:@"#a1a1a1"];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(line1);
        make.left.mas_equalTo(label);
        make.width.mas_equalTo(label);
        make.height.mas_equalTo(1);
    }];
    
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(line1.mas_bottom).offset(E_RealHeight(55));
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(300), E_RealHeight(50)));
    }];
}


#pragma mark - *** Actions

- (void)nextAction{
    
    if (![JXCheckTool isMobile:self.phoneTextF.text] || kStringIsEmpty(self.phoneTextF.text)) {
        return [self showHint:@"请输入正确的手机号!"];
    }
    
    if ([self.phoneTextF.text isEqualToString:[EUserInfoManager getUserInfo].mobile]) {
        return [self showHint:@"该手机号与当前绑定的手机号相同!"];
    }
    
    [ELoginViewModel getCodeWithMobile:self.phoneTextF.text completion:^(BOOL isSuccess) {
        if (isSuccess) {
            EValidateCodeViewController *vc = [[EValidateCodeViewController alloc]init];
            vc.mobile = self.phoneTextF.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    
}


#pragma mark - *** UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phoneTextF) {
        
         if (range.location >= 11) return NO;
    }
    
    return YES;
    
}

@end
