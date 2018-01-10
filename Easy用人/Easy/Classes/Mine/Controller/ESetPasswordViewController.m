//
//  ESetPasswordViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/21.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ESetPasswordViewController.h"
#import "EUserModel.h"
#import "ELoginViewModel.h"
#import "EMineViewModel.h"

@interface ESetPasswordViewController ()
@property (nonatomic, strong) UITextField *codeTextF;
@property (nonatomic, strong) UITextField *setPsdTextF;
@property (nonatomic, strong) UITextField *rePsdTextF;
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *getCodeBtn;

@property(strong,nonatomic) NSTimer *timer;
/** 时间 */
@property (nonatomic, assign) int time;
@end

@implementation ESetPasswordViewController

#pragma mark - *** lazy load
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


- (UIButton *)getCodeBtn{
    if (_getCodeBtn == nil) {
        _getCodeBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] normalColor:[UIColor colorWithHexString:@"#ffcd38"] selectColor:nil title:@"获取验证码" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(getCodeAction:)];
        _getCodeBtn.cornerRadius = 5;
        _getCodeBtn.borderWidth = 1;
        _getCodeBtn.borderColor = [UIColor colorWithHexString:@"#ffcd38"].CGColor;
        _getCodeBtn.backgroundColor = [UIColor whiteColor];
    }
    return _getCodeBtn;
}

#pragma mark - *** cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
    self.getCodeBtn.enabled = YES;
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}


#pragma mark - *** Private Method
- (void)setupUI{
    
    /// 验证码
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.codeTextF = [[UITextField alloc]init];
    self.codeTextF.placeholder = @"请输入验证码";
    self.codeTextF.font = [UIFont systemFontOfSize:E_FontRadio(14)];
    self.codeTextF.backgroundColor = [UIColor whiteColor];
    self.codeTextF.cornerRadius = 5;
    self.codeTextF.leftView = leftView;
    self.codeTextF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.codeTextF];
    [self.codeTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(E_RealWidth(200), E_RealHeight(44)));
        make.left.mas_equalTo(self.view).offset((kScreenW - E_RealWidth(300)) * 0.5);
        make.top.mas_equalTo(E_RealHeight(42) + E_StatusBarAndNavigationBarHeight);
    }];
    
    [self.view addSubview:self.getCodeBtn];
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.codeTextF);
        make.height.mas_equalTo(E_RealHeight(44));
        make.left.mas_equalTo(self.codeTextF.mas_right).offset(E_RealWidth(10));
        make.width.mas_equalTo(E_RealWidth(90));
    }];
    
    
    UILabel *originLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#4d4d4d"] text:[NSString stringWithFormat:@"手机号:%@",[EUserInfoManager getUserInfo].mobile] textAlignment:0];
    [self.view addSubview:originLabel];
    [originLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.codeTextF.mas_top).offset(-E_RealHeight(6));
        make.left.mas_equalTo(self.codeTextF);
    }];
    
    
    /// 新密码
    UIView *leftView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.setPsdTextF = [[UITextField alloc]init];
    self.setPsdTextF.placeholder = @"请输入新密码";
    self.setPsdTextF.font = [UIFont systemFontOfSize:E_FontRadio(14)];
    self.setPsdTextF.backgroundColor = [UIColor whiteColor];
    self.setPsdTextF.cornerRadius = 5;
    self.setPsdTextF.leftView = leftView2;
    self.setPsdTextF.leftViewMode = UITextFieldViewModeAlways;
    self.setPsdTextF.keyboardType = UIKeyboardTypeNamePhonePad;
    self.setPsdTextF.secureTextEntry = YES;
    [self.view addSubview:self.setPsdTextF];
    [self.setPsdTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(E_RealWidth(300), E_RealHeight(44)));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.codeTextF.mas_bottom).offset(E_RealHeight(42));
    }];
    
    UILabel *changeLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#4d4d4d"] text:@"新密码:" textAlignment:0];
    [self.view addSubview:changeLabel];
    [changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.setPsdTextF.mas_top).offset(-E_RealHeight(6));
        make.left.mas_equalTo(self.setPsdTextF);
    }];
    
    
    
    /// 确定新密码
    UIView *leftView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    self.rePsdTextF = [[UITextField alloc]init];
    self.rePsdTextF.placeholder = @"请输入新密码";
    self.rePsdTextF.font = [UIFont systemFontOfSize:E_FontRadio(14)];
    self.rePsdTextF.backgroundColor = [UIColor whiteColor];
    self.rePsdTextF.cornerRadius = 5;
    self.rePsdTextF.leftView = leftView3;
    self.rePsdTextF.leftViewMode = UITextFieldViewModeAlways;
    self.rePsdTextF.keyboardType = UIKeyboardTypeNamePhonePad;
    self.rePsdTextF.secureTextEntry = YES;
    [self.view addSubview:self.rePsdTextF];
    [self.rePsdTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(E_RealWidth(300), E_RealHeight(44)));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.setPsdTextF.mas_bottom).offset(E_RealHeight(42));
    }];
    
    UILabel *sureNewLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#4d4d4d"] text:@"确认新密码:" textAlignment:0];
    [self.view addSubview:sureNewLabel];
    [sureNewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.rePsdTextF.mas_top).offset(-E_RealHeight(6));
        make.left.mas_equalTo(self.rePsdTextF);
    }];
    
    /// 确定
    UILabel *sureLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#9a9a9a"] text:@"密码由6-20位英文字母、数组或者符号组成" textAlignment:0];
    [self.view addSubview:sureLabel];
    [sureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.rePsdTextF.mas_bottom).offset(E_RealHeight(19));
    }];
    
    [self.view addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(sureLabel.mas_bottom).offset(E_RealHeight(37));
        make.size.mas_equalTo(CGSizeMake(E_RealWidth(300), E_RealHeight(50)));
    }];
    
}

#pragma mark - *** Actions
- (void)getCodeAction:(UIButton *)button{
    
    
    [ELoginViewModel getCodeWithMobile:[EUserInfoManager getUserInfo].mobile completion:^(BOOL isSuccess) {
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

- (void)sureAction:(UIButton *)button{
    if (kStringIsEmpty(self.codeTextF.text)) {
        return [self showHint:@"请输入验证码"];
    }
    
    if (kStringIsEmpty(self.setPsdTextF.text)) {
        return [self showHint:@"请输入新密码"];
    }
    
    if (kStringIsEmpty(self.rePsdTextF.text)) {
        return [self showHint:@"请再输入一次新密码"];
    }
    
    [EMineViewModel setPassword:self.setPsdTextF.text rePassword:self.rePsdTextF.text code:self.codeTextF.text completion:^(BOOL isSuccess) {
        if (isSuccess) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else{
            _time = 0;
        }
        
    }];
    
}
@end
