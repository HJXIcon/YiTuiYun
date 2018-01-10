//
//  ForgetViewController.m
//  yituiyun
//
//  Created by NIT on 15-3-11.
//  Copyright (c) 2015年 NIT. All rights reserved.
//

#import "ForgetViewController.h"

#define TIMERCODE 60

@interface ForgetViewController ()<UITextFieldDelegate>
@property(strong,nonatomic) UITextField *textFieldPhoneNumber;    //输手机号
@property(strong,nonatomic) UITextField *textFieldOne;      //输入密码
@property(strong,nonatomic) UITextField *textFieldCode;     //验证码
@property(strong,nonatomic) UIButton *buttonCode;           //获取验证码button
@property(assign,nonatomic) int codeTimer;                  //时间
@property(assign,nonatomic) BOOL isFrist;                   //是否再次发送验证码
@property(strong,nonatomic) NSTimer *timerCode;             //定时器
@property(assign,nonatomic) BOOL isShow;                    //密码是否显示
@property(assign,nonatomic) BOOL isAgreement;               //协议是否选择
@property(copy,nonatomic) NSString *code;                   //返回的验证码，用于验证
@end

@implementation ForgetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kUIColorFromRGB(0xffffff);

    [self setupNav];
    [self loadStatusView];
}

#pragma mark - setupNav
- (void)setupNav{
    [self.navigationController.navigationBar setTranslucent:YES];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    label.text = @"找回密码";
    label.textColor = kUIColorFromRGB(0xf16156);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"backRed" selectedImage:@"backRed" target:self action:@selector(leftBtnDidClick)];
    
    UIView *lineView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(0, 64, ZQ_Device_Width, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView];
}

- (void)leftBtnDidClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  加载控件
-(void)loadStatusView
{
    //点击键盘消失
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressedKeybordHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指
    singleFingerOne.numberOfTapsRequired = 1;    //tap次数
    singleFingerOne.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleFingerOne];
    
    //手机号TextField
    self.textFieldPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, ZQ_Device_Width - 60, 30)];
    _textFieldPhoneNumber.placeholder = @"请输入已注册的手机号";
    [_textFieldPhoneNumber setValue:kUIColorFromRGB(0xcccccc) forKeyPath:@"placeholderLabel.textColor"];
    _textFieldPhoneNumber.textAlignment = NSTextAlignmentLeft;
    _textFieldPhoneNumber.borderStyle = UITextBorderStyleNone;
    _textFieldPhoneNumber.font = [UIFont systemFontOfSize:15.f];
    _textFieldPhoneNumber.delegate = self;
    _textFieldPhoneNumber.textColor = [UIColor blackColor];
    _textFieldPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_textFieldPhoneNumber];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_textFieldPhoneNumber.frame), ZQ_Device_Width - 40, 2)];
    lineView.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView];
    
    //验证码TextField
    self.textFieldCode = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(lineView.frame) + 30, ZQ_Device_Width - 141.5, 30)];
    _textFieldCode.placeholder = @"请输入验证码";
    [_textFieldCode setValue:kUIColorFromRGB(0xcccccc) forKeyPath:@"placeholderLabel.textColor"];
    _textFieldCode.textAlignment = NSTextAlignmentLeft;
    _textFieldCode.keyboardType = UIKeyboardTypeDefault;
    _textFieldCode.font = [UIFont systemFontOfSize:15.f];
    _textFieldCode.delegate = self;
    [_textFieldCode setKeyboardType:UIKeyboardTypeASCIICapable];
    [_textFieldCode setReturnKeyType:UIReturnKeyDone];
    _textFieldCode.textColor = [UIColor blackColor];
    [self.view addSubview:_textFieldCode];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_textFieldCode.frame), ZQ_Device_Width - 40, 2)];
    lineView1.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(ZQ_Device_Width - 101.5, CGRectGetMinY(lineView1.frame) - 30, 1.5, 30)];
    lineView2.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView2];
    
    //验证码
    self.codeTimer = TIMERCODE;
    self.isFrist = YES;
    _buttonCode = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonCode.frame = CGRectMake(ZQ_Device_Width - 100, CGRectGetMinY(lineView1.frame) - 30, 80, 30);
    _buttonCode.userInteractionEnabled = YES;
//    _buttonCode.layer.cornerRadius = 10;
//    _buttonCode.layer.masksToBounds = YES;
    _buttonCode.tag = 100;
    _buttonCode.titleLabel.font = [UIFont systemFontOfSize:13];
    [_buttonCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_buttonCode setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
    _buttonCode.backgroundColor = [UIColor clearColor];
    [_buttonCode addTarget:self action:@selector(keyboardHidden:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonCode];
    
    self.textFieldOne = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(lineView1.frame) + 30, ZQ_Device_Width - 70, 30)];
    _textFieldOne.placeholder = @"请输入新密码";
    [_textFieldOne setValue:kUIColorFromRGB(0xcccccc) forKeyPath:@"placeholderLabel.textColor"];
    _textFieldOne.textAlignment = NSTextAlignmentLeft;
    _textFieldOne.keyboardType = UIKeyboardTypeDefault;
    _textFieldOne.font = [UIFont systemFontOfSize:15.f];
    _textFieldOne.delegate = self;
//    _textFieldOne.clearsOnBeginEditing = YES;       //再次编辑的时候，清空内部文字
    _textFieldOne.secureTextEntry = YES;            //使内容以保密圆点方式显示
    [_textFieldOne setKeyboardType:UIKeyboardTypeASCIICapable];
    [_textFieldOne setReturnKeyType:UIReturnKeyDone];
    _textFieldOne.textColor = [UIColor blackColor];
    [self.view addSubview:_textFieldOne];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_textFieldOne.frame), ZQ_Device_Width - 40, 2)];
    lineView3.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView3];
    
    UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eyeBtn.frame = CGRectMake(ZQ_Device_Width - 60, CGRectGetMaxY(lineView3.frame) - 30, 35, 35);
    [eyeBtn setImage:[UIImage imageNamed:@"sercert_no"] forState:UIControlStateNormal];
    [eyeBtn addTarget:self action:@selector(eyeBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:eyeBtn];
    
    UIButton *buttonCenter = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonCenter setFrame:CGRectMake(20, CGRectGetMaxY(_textFieldOne.frame) + 30, ZQ_Device_Width - 40, 50)];
    [buttonCenter setTitle:@"确认" forState:UIControlStateNormal];
    [buttonCenter setTintColor:[UIColor whiteColor]];
    buttonCenter.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [[buttonCenter layer] setCornerRadius:4];
    [[buttonCenter layer] setMasksToBounds:YES];
    buttonCenter.backgroundColor = kUIColorFromRGB(0xf16156);
    [buttonCenter addTarget:self action:@selector(buttonPressedClickStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonCenter];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)eyeBtnClick:(UIButton *)sender
{
    _textFieldOne.secureTextEntry = _isShow;
    
    
    if (_isShow == NO) {
        _isShow = YES;
        [sender setImage:[UIImage imageNamed:@"sercert_yes"] forState:UIControlStateNormal];
    } else {
        NSString *text = _textFieldOne.text;
        _textFieldOne.text = @"";
        _textFieldOne.text = text;
        _isShow = NO;
         [sender setImage:[UIImage imageNamed:@"sercert_no"] forState:UIControlStateNormal];
    }
}

//键盘隐藏
-(void)buttonPressedKeybordHidden
{
    [self.textFieldPhoneNumber resignFirstResponder];
    [self.textFieldCode resignFirstResponder];
    [self.textFieldOne resignFirstResponder];
}

- (void)resignFirstResponder:(NSNotification *)notif
{
    [self buttonPressedKeybordHidden];
}

#pragma mark
#pragma mark  button 事件
-(void)keyboardHidden:(UIButton *)button
{
    [self.textFieldPhoneNumber resignFirstResponder];
    [self.textFieldOne resignFirstResponder];
    [self.textFieldCode resignFirstResponder];
    
    //手机位判断
    if (_textFieldPhoneNumber.text.length < 11 || [ZQ_CommonTool isEmpty:_textFieldPhoneNumber.text]) {
        [ZQ_UIAlertView showMessage:@"请输入11位手机号" cancelTitle:@"确定"];
        return;
    }
    
    button.userInteractionEnabled=NO;
    _timerCode = [NSTimer scheduledTimerWithTimeInterval: 1
                                                  target: self
                                                selector: @selector(timerFireMethod:)
                                                userInfo: nil
                                                 repeats: YES];
    [[NSRunLoop currentRunLoop]addTimer:_timerCode forMode:UITrackingRunLoopMode];
    
}

-(void)timerFireMethod:(NSTimer *)theTimer
{
    NSString *timer = [NSString stringWithFormat:@"%dS", _codeTimer];
    _codeTimer --;
    if (_codeTimer > 0) {
        if (_isFrist) {
            if (TIMERCODE - _codeTimer == 1) {
                [self getNewCode];
            }
        }
        [_buttonCode setTitle:timer forState:0];
        [_buttonCode setTitleColor:kUIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }else {
        _isFrist = YES;
        [_buttonCode setTitle:@"重发验证码" forState:0];
        _buttonCode.userInteractionEnabled = YES;
        _codeTimer = TIMERCODE;
        [_timerCode invalidate];
        _timerCode = nil;
        [_buttonCode setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
    }
}

#pragma mark
#pragma mark 得到新的验证码
-(void)getNewCode
{
    self.buttonCode.userInteractionEnabled = NO;
    if ([[Reachability reachabilityForInternetConnection] isReachable]){
        
        [self sendRequestGetSMS];
        
    } else {
        self.buttonCode.userInteractionEnabled = YES;
        [self showHint:@"当前网络不可用，请检查您的网络设置。" yOffset:-200];
    }
}

- (void)sendRequestGetSMS
{
    [self showHudInView1:self.view hint:@"加载中..."];
    __weak ForgetViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = _textFieldPhoneNumber.text;
    params[@"t"] = @"2";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=login.send_pcode"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        NSDictionary *dic = responseObject[@"rst"];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            weakSelf.code = [NSString stringWithFormat:@"%@", dic[@"code"]];
            [weakSelf showHint:@"验证码已发送，请查收"];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
            _isFrist = YES;
            [_buttonCode setTitle:@"发送验证码" forState:0];
            _buttonCode.userInteractionEnabled = YES;
            _codeTimer = TIMERCODE;
            [_timerCode invalidate];
            _timerCode = nil;
            [_buttonCode setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        _isFrist = YES;
        [_buttonCode setTitle:@"发送验证码" forState:0];
        _buttonCode.userInteractionEnabled = YES;
        _codeTimer = TIMERCODE;
        [_timerCode invalidate];
        _timerCode = nil;
        [_buttonCode setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试" yOffset:-200];
}];
}
#pragma mark - 确认更改
- (void)buttonPressedClickStatus:(UIButton *)button
{
    [button setUserInteractionEnabled:NO];
    [self.textFieldCode resignFirstResponder];
    [self.textFieldOne resignFirstResponder];
    [self.textFieldPhoneNumber resignFirstResponder];
    
    
    //检测验证码、密码是否符合规则
    if (![[NStringFormatJudgment sharedNStringFormatJudgment] submitNewPassWordFormatJudgment:self.textFieldCode.text andOnePass:self.textFieldOne.text]) {
        [button setUserInteractionEnabled:YES];
        return;
    }
    
    if (![self.textFieldCode.text isEqualToString:self.code]) {
        [self showHint:@"验证码错误"];
        [button setUserInteractionEnabled:YES];
        return;
    }
    
    [self modifyConfiguration:button];
    
}


- (void)modifyConfiguration:(UIButton *)button
{
    [self showHudInView1:self.view hint:@"加载中..."];
    __weak ForgetViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = _textFieldPhoneNumber.text;
    NSString *PsdStr = self.textFieldOne.text;
    params[@"password"] = PsdStr;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=user.updatePassword"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {

        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:responseObject[@"errmsg"]
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     [weakSelf.navigationController popViewControllerAnimated:YES];
                 }
             } cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
        [button setUserInteractionEnabled:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [button setUserInteractionEnabled:YES];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试" yOffset:-200];
    }];

}

#pragma mark
#pragma mark UItextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    
    if(textField == self.textFieldPhoneNumber){
        if(proposedNewLength > 11){
            return NO;
        }
        return YES;
    }else if (textField == self.textFieldOne){
        if(proposedNewLength > 20){
            return NO;
        }
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
