//
//  ERegisterViewController.m
//  Easy
//
//  Created by yituiyun on 2017/11/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ERegisterViewController.h"
#import "EPerfectInfoViewController.h"
#import "ELoginViewModel.h"
#import "EWebViewController.h"

@interface ERegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UITextField *codeTextF;
@property (nonatomic, strong) UITextField *psdTextF;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) UIButton *boxBtn;
@property (nonatomic, strong) UIButton *registerBtn;

@property(strong,nonatomic) NSTimer *timer;
/** 时间 */
@property (nonatomic, assign) int time;

@end

@implementation ERegisterViewController

#pragma mark - *** Cycle Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupUI];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self invalidateTimer];
}

#pragma mark - *** private Method

- (void)invalidateTimer{
    [_timer invalidate];
    _timer = nil;
    self.getCodeBtn.enabled = YES;
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}

#pragma mark - *** UI

- (void)setupNav{
    self.navigationItem.title = @"注册";
    
}

- (void)setupUI{
    
    /// 手机号码
    UILabel *phoneLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#565656"] text:@"手机号码:" textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(E_RealWidth(10));
        make.top.mas_equalTo(E_RealHeight(20) + E_StatusBarAndNavigationBarHeight);
        make.height.mas_equalTo(E_RealHeight(44));
    }];
    
    self.phoneTextF = [[UITextField alloc]init];
    self.phoneTextF.font = [UIFont systemFontOfSize:E_FontRadio(16)];
    self.phoneTextF.placeholder = @"手机号码";
    self.phoneTextF.delegate = self;
    [self.view addSubview:self.phoneTextF];
    [self.phoneTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel.mas_right).offset(E_RealWidth(10));
        make.centerY.mas_equalTo(phoneLabel);
        make.width.mas_equalTo(E_RealWidth(180));
    }];
   
    
    UIView *line0 = [[UIView alloc]init];
    line0.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [self.view addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(phoneLabel.mas_bottom);
    }];
    
    
    
    /// 验证码
    UILabel *codeLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#565656"] text:@" 验 证 码 :" textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:codeLabel];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel);
        make.top.mas_equalTo(line0.mas_bottom).offset(E_RealHeight(11));
        make.height.mas_equalTo(E_RealHeight(44));
    }];
    
    self.getCodeBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(15)] normalColor:[UIColor colorWithHexString:@"#ffbf00"] selectColor:[UIColor colorWithHexString:@"#ffbf00"] title:@"获取验证码" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(getCodeAction:)];
    self.getCodeBtn.borderWidth = 1;
    self.getCodeBtn.borderColor = [UIColor colorWithHexString:@"#ffcd38"].CGColor;
    self.getCodeBtn.cornerRadius = 3;
    CGSize getCodeSize = CGSizeMake(E_RealWidth(87), E_RealHeight(35));
    [self.view addSubview:self.getCodeBtn];
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line0.mas_bottom).offset(E_RealHeight(9));
        make.right.mas_equalTo(self.view.mas_right).offset(E_RealWidth(-10));
        make.size.mas_equalTo(getCodeSize);
    }];
    
    self.codeTextF = [[UITextField alloc]init];
    self.codeTextF.font = [UIFont systemFontOfSize:E_FontRadio(16)];
    self.codeTextF.placeholder = @"验证码";
    [self.view addSubview:self.codeTextF];
    [self.codeTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(codeLabel);
        make.left.mas_equalTo(self.phoneTextF);
        make.width.mas_equalTo(E_RealWidth(180));
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(codeLabel.mas_bottom);
    }];
    
    
    /// 密码
    UILabel *psdLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#565656"] text:@" 密    码 :" textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:psdLabel];
    [psdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel);
        make.top.mas_equalTo(line1.mas_bottom).offset(E_RealHeight(11));
        make.height.mas_equalTo(E_RealHeight(44));
    }];
    
    self.psdTextF = [[UITextField alloc]init];
    self.psdTextF.placeholder = @"6-20位数字或字母";
    self.psdTextF.font = [UIFont systemFontOfSize:E_FontRadio(16)];
    self.psdTextF.keyboardType = UIKeyboardTypeNamePhonePad;
    self.psdTextF.secureTextEntry = YES;
    self.psdTextF.delegate = self;
    [self.view addSubview:self.psdTextF];
    [self.psdTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(psdLabel);
        make.left.mas_equalTo(self.phoneTextF);
        make.width.mas_equalTo(E_RealWidth(180));
    }];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = [UIColor colorWithHexString:@"0xf0f0f0"];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(psdLabel.mas_bottom);
    }];
    
    /// 背景View
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:bgView atIndex:0];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(E_StatusBarAndNavigationBarHeight);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(line2);
    }];
    
    
    /// 协议
    self.boxBtn = [JXFactoryTool creatButton:CGRectZero font:nil normalColor:nil selectColor:nil title:nil nornamlImageName:@"" selectImageName:@"" textAlignment:0 target:self action:@selector(boxAction:)];
    [self.boxBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"]] forState:UIControlStateNormal];
    [self.boxBtn setBackgroundImage:[UIImage imageNamed:@"gouxuan-yigou"] forState:UIControlStateSelected];
    self.boxBtn.borderWidth = 1;
    self.boxBtn.borderColor = [UIColor colorWithHexString:@"#bfbfbf"].CGColor;
    [self.view addSubview:self.boxBtn];
    self.boxBtn.selected = YES;
    [self.boxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(E_RealWidth(54));
        make.height.width.mas_equalTo(E_RealWidth(15));
        make.top.mas_equalTo(line2.mas_bottom).offset(E_RealHeight(20));
    }];
    
    UILabel *blackLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor colorWithHexString:@"#575757"] text:@"我已经阅读并同意" textAlignment:0];
    [self.view addSubview:blackLabel];
    CGSize blackSize = [blackLabel jx_sizeToFitWithHorizontal:0 vertical:0];
    [blackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.boxBtn);
        make.left.mas_equalTo(self.boxBtn.mas_right).offset(5);
        make.size.mas_equalTo(blackSize);
    }];
    
    
    UILabel *protocolLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor colorWithHexString:@"#4baafe"] text:@"《易企算用户协议》" textAlignment:0];
    protocolLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(protocolAction)];
    [protocolLabel addGestureRecognizer:tap];
    [self.view addSubview:protocolLabel];
    CGSize protocolSize = [protocolLabel jx_sizeToFitWithHorizontal:0 vertical:0];
    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.boxBtn);
        make.left.mas_equalTo(blackLabel.mas_right);
        make.size.mas_equalTo(protocolSize);
    }];
    
    
    
    // 注册
    self.registerBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:18] normalColor:[UIColor whiteColor] selectColor:nil title:@"注册" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(registerAction)];
    [self.view addSubview:self.registerBtn];
    UIImage *nornamlImage = [UIImage imageGradientWithFrame:CGRectMake(0, 0, E_RealWidth(300), E_RealHeight(50)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
    [self.registerBtn setBackgroundImage:nornamlImage forState:UIControlStateNormal];
    [self.registerBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
    self.registerBtn.cornerRadius = E_RealHeight(25);
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom).offset(E_RealHeight(64));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(E_RealWidth(300));
        make.height.mas_equalTo(E_RealHeight(50));
    }];
}



#pragma mark - *** Actions

- (void)registerAction{
    
    if (kStringIsEmpty(self.phoneTextF.text)) {
        [self showHint:@"请输入手机号"];
        return;
    }
    if (kStringIsEmpty(self.codeTextF.text)) {
        [self showHint:@"请输入验证码"];
        return;
    }
    if (kStringIsEmpty(self.psdTextF.text)) {
        [self showHint:@"请输入密码"];
        return;
    }
    if (!self.boxBtn.selected) {
        [self showHint:@"需要同意协议才能注册"];
        return;
    }
    if (self.psdTextF.text.length < 6) {
        [self showHint:@"密码应为6-20位数字或字母"];
        return;
    }
    
    [ELoginViewModel RegisterWithMobile:self.phoneTextF.text password:self.psdTextF.text verifyCode:self.codeTextF.text type:@"0" completion:^(EUserModel *model) {
        
        _time = 0;
        /// model有值表示注册成功
        if (model) {
            [EUserInfoManager saveUserInfo:model];
            EPerfectInfoViewController *vc = [[EPerfectInfoViewController alloc]init];
            vc.status = EPerfectInfoAfterResisterStatus;
            [self.navigationController pushViewController:vc animated:YES];
        }
       
    }];
}

- (void)protocolAction{
    EWebViewController *vc = [[EWebViewController alloc]init];
    vc.urlString = E_ApiRequset(kAgreement);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)boxAction:(UIButton *)button{
    button.selected = !button.selected;
    
    if (button.selected) {
        self.boxBtn.borderWidth = 0;
        self.boxBtn.borderColor = nil;
    }else{
        self.boxBtn.borderWidth = 1;
        self.boxBtn.borderColor = [UIColor colorWithHexString:@"#bfbfbf"].CGColor;
    }
}

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

#pragma mark - *** UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phoneTextF) {
        if (range.location >= 11) return NO;
    }
    
    if (textField == self.psdTextF) {
         if (range.location >= 20) return NO;
    }
    
    return YES;
    
}
@end
