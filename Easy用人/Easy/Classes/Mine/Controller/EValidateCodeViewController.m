//
//  EValidateCodeViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/4.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EValidateCodeViewController.h"
#import "ELoginViewModel.h"
#import "EUserModel.h"

@interface EValidateCodeViewController ()
@property (nonatomic, strong) UITextField *codeTextF;
@property (nonatomic, strong) UIButton *nextBtn;
@end

@implementation EValidateCodeViewController

#pragma mark - *** lazy load
- (UIButton *)nextBtn{
    if (_nextBtn == nil) {
        _nextBtn = [JXFactoryTool creatButton:CGRectMake(0, 44 * 4, E_RealWidth(130), E_RealHeight(50)) font:[UIFont systemFontOfSize:E_FontRadio(18)] normalColor:[UIColor whiteColor] selectColor:nil title:@"下一步" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(nextAction)];
        _nextBtn.centerX = self.view.centerX;
        UIImage *norImage = [UIImage imageGradientWithFrame:CGRectMake(0, 0, E_RealWidth(130), E_RealHeight(50)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
        _nextBtn.cornerRadius = E_RealHeight(25);
        [_nextBtn setBackgroundImage:norImage forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
        
    }
    return _nextBtn;
}

- (UITextField *)codeTextF{
    if (_codeTextF == nil) {
        _codeTextF = [[UITextField alloc]init];
        _codeTextF.textAlignment = NSTextAlignmentCenter;
        _codeTextF.placeholder = @"验证码";
        _codeTextF.font = [UIFont systemFontOfSize:E_FontRadio(16)];
        _codeTextF.cornerRadius = 5;
        _codeTextF.backgroundColor = [UIColor whiteColor];
    }
    return _codeTextF;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"填写验证码";
    [self setupUI];
}

- (void)setupUI{
    [self.view addSubview:self.codeTextF];
    [self.codeTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(E_RealHeight(55) + E_StatusBarAndNavigationBarHeight);
        make.left.mas_equalTo(E_RealWidth(23));
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(185), E_RealHeight(50)));
    }];
    
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-E_RealWidth(23));
        make.centerY.mas_equalTo(self.codeTextF);
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(130), E_RealHeight(50)));
    }];
}


#pragma mark - *** Actions
- (void)nextAction{
    
    
    if (kStringIsEmpty(self.codeTextF.text)) {
        return [self showHint:@"请输入验证码"];
    }
    
    [ELoginViewModel updateMobileWithMobile:self.mobile useId:[EUserInfoManager getUserInfo].userId verifyCode:self.codeTextF.text completion:^() {
        [EUserInfoManager removeUserInfo];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].keyWindow.rootViewController = [EControllerManger chooseRootController];
        });
    }];
}
@end
