//
//  EGetBackPsdViewController.m
//  Easy
//
//  Created by yituiyun on 2017/11/28.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EGetBackPsdViewController.h"
#import "ELoginViewModel.h"

@interface EGetBackPsdViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UITextField *codeTextF;
@property (nonatomic, strong) UITextField *psdTextF;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *getCodeBtn;

@property(strong,nonatomic) NSTimer *timer;
/** 时间 */
@property (nonatomic, assign) int time;
@end

@implementation EGetBackPsdViewController

#pragma mark - *** lazy load
- (UITextField *)phoneTextF{
    if (_phoneTextF == nil) {
        _phoneTextF = [[UITextField alloc]init];
        _phoneTextF.placeholder = @"请输入已注册手机号码";
        _phoneTextF.font = [UIFont systemFontOfSize:E_FontRadio(16)];
        _phoneTextF.backgroundColor = [UIColor whiteColor];
        _phoneTextF.cornerRadius = 5;
        _phoneTextF.delegate = self;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        leftView.backgroundColor = [UIColor whiteColor];
        _phoneTextF.leftView = leftView;
        _phoneTextF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneTextF;
}

- (UITextField *)psdTextF{
    if (_psdTextF == nil) {
        _psdTextF = [[UITextField alloc]init];
        _psdTextF.placeholder = @"请输入新密码";
        _psdTextF.font = [UIFont systemFontOfSize:E_FontRadio(16)];
        _psdTextF.backgroundColor = [UIColor whiteColor];
        _psdTextF.cornerRadius = 5;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        leftView.backgroundColor = [UIColor whiteColor];
        _psdTextF.leftView = leftView;
        _psdTextF.leftViewMode = UITextFieldViewModeAlways;
        _psdTextF.keyboardType = UIKeyboardTypeNamePhonePad;
        _psdTextF.secureTextEntry = YES;
    }
    return _psdTextF;
}

- (UITextField *)codeTextF{
    if (_codeTextF == nil) {
        _codeTextF = [[UITextField alloc]init];
        _codeTextF.placeholder = @"请输入验证码";
        _codeTextF.font = [UIFont systemFontOfSize:E_FontRadio(16)];
        _codeTextF.backgroundColor = [UIColor whiteColor];
        _codeTextF.cornerRadius = 5;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        leftView.backgroundColor = [UIColor whiteColor];
        _codeTextF.leftView = leftView;
        _codeTextF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _codeTextF;
}

- (UIButton *)getCodeBtn{
    if (_getCodeBtn == nil) {
        _getCodeBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] normalColor:[UIColor colorWithHexString:@"#ffcd38"] selectColor:nil title:@"获取验证码" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(getCodeAction:)];
        _getCodeBtn.cornerRadius = 5;
        _getCodeBtn.borderWidth = 1;
        _getCodeBtn.borderColor = [UIColor colorWithHexString:@"#ffcd38"].CGColor;
    }
    return _getCodeBtn;
}

- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:E_FontRadio(18)];
        UIImage *nornamlImage = [UIImage imageGradientWithFrame:CGRectMake(0, 0, E_RealWidth(300), E_RealHeight(50)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
        [_sureBtn setBackgroundImage:nornamlImage forState:UIControlStateNormal];
    }
    return _sureBtn;
}


#pragma mark - *** Cycle Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"找回密码";
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
    self.getCodeBtn.enabled = YES;
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}

#pragma mark - *** UI
- (void)setupUI{
    ///
    [self.view addSubview:self.phoneTextF];
    [self.phoneTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(E_RealHeight(77/2) + E_StatusBarAndNavigationBarHeight);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(E_RealWidth(300));
        make.height.mas_equalTo(E_RealHeight(44));
    }];
    
    ///
    [self.view addSubview:self.codeTextF];
    [self.codeTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneTextF.mas_bottom).offset(E_RealHeight(26));
        make.left.mas_equalTo(self.phoneTextF);
        make.height.mas_equalTo(E_RealHeight(44));
        make.width.mas_equalTo(E_RealWidth(185));
    }];
    
    /// 获取验证码
    [self.view addSubview:self.getCodeBtn];
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.codeTextF);
        make.height.mas_equalTo(E_RealHeight(44));
        make.left.mas_equalTo(self.codeTextF.mas_right).offset(E_RealWidth(10));
        make.width.mas_equalTo(E_RealWidth(105));
    }];
    
    /// 设置新密码
    [self.view addSubview:self.psdTextF];
    [self.psdTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneTextF);
        make.top.mas_equalTo(self.codeTextF.mas_bottom).offset(E_RealHeight(83/2));
        make.width.height.mas_equalTo(self.phoneTextF);
        }];
    
    UILabel *psdLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#4d4d4d"] text:@"设置新密码:" textAlignment:0];
    [self.view addSubview:psdLabel];
    [psdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneTextF);
        make.bottom.mas_equalTo(self.psdTextF.mas_top).offset(-E_RealHeight(6));
    }];
    
    
    /// 确定按钮
    self.sureBtn.cornerRadius = E_RealHeight(25);
    [self.view addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.psdTextF.mas_bottom).offset(E_RealHeight(65));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(E_RealWidth(300));
        make.height.mas_equalTo(E_RealHeight(50));
    }];
    
}

#pragma mark - *** Actions
- (void)getCodeAction:(UIButton *)button{
    
    if (![JXCheckTool isMobile:self.phoneTextF.text]) {
        [self showHint:@"请输入正确手机号!"];
        return;
    }
    
    [ELoginViewModel getCodeWithMobile:self.phoneTextF.text completion:^(BOOL isSuccess) {
        if (isSuccess) {
            /// 添加定时器
            _time = 60;
            self.getCodeBtn.titleLabel.text = [NSString stringWithFormat:@"已发送60s"];
            [self.getCodeBtn setTitle:[NSString stringWithFormat:@"已发送%ds",_time] forState:UIControlStateNormal];
            self.getCodeBtn.enabled = NO;
            
            if (_timer == nil) {
                _timer = [NSTimer scheduledTimerWithTimeInterval: 1
                                                          target: self
                                                        selector: @selector(timerAction:)
                                                        userInfo: nil
                                                         repeats: YES];
                [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
            }
        }
    }];
    
    
}

- (void)timerAction:(NSTimer *)theTimer{
    _time --;
    if (_time > 0) {
        self.getCodeBtn.titleLabel.text = [NSString stringWithFormat:@"已发送%ds",_time];
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"已发送%ds",_time] forState:UIControlStateNormal];
        self.getCodeBtn.enabled = NO;
        
    }else {
        
        self.getCodeBtn.enabled = YES;
        [self.getCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    }
}


- (void)sureAction{
    
    
    if (kStringIsEmpty(self.codeTextF.text)) {
        [self showHint:@"请输入验证码"];
        return;
    }
    
    if (kStringIsEmpty(self.psdTextF.text)) {
        [self showHint:@"请输入密码"];
        return;
    }
    
    [ELoginViewModel findPasswordWithMobile:self.phoneTextF.text verifyCode:self.codeTextF.text password:self.psdTextF.text completion:^(BOOL isSuccess, NSString *errmsg) {
        [self showHint:errmsg];
        if (isSuccess) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].keyWindow.rootViewController = [EControllerManger chooseRootController];
            });
        }
        else{
            _time = 0;
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
