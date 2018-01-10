//
//  RegisterController.m
//  yituiyun
//
//  Created by Messi on 14-6-10.
//  Copyright (c) 2014年 xiaoyu-ys. All rights reserved.
//
#import "RegisterController.h"
#import "AgreementViewController.h"
#import "AboutMyViewController.h"
#import "NSString+LHKExtension.h"
#define TIMERCODE 60

@interface RegisterController ()<UITextFieldDelegate>
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
@property(assign,nonatomic) NSInteger where;
@property(copy,nonatomic) NSString *openId;
@property(copy,nonatomic) NSString *loginType;
@property(copy,nonatomic) NSString *nickname;
@property(copy,nonatomic) NSString *avatar;
@property (nonatomic, copy) NSString *identity; //身份

@property(nonatomic,strong) UITextField * recommandTel;

@property(nonatomic,strong) UIView * registerPanView;
@property(nonatomic,strong) UIButton * registerBtn;
// 用户使用协议
@property(nonatomic,strong) UILabel * shoumingLabel;
// 专职用户协议
@property(nonatomic,strong) UILabel * fullTimeAgreementLabel;

@property(nonatomic,strong) UIImageView * iconView;
@property(nonatomic,strong) UILabel * nameLabel;

@property(nonatomic,strong) NSString * ID;
@property(nonatomic,strong) NSString * uModelid;
@property(nonatomic,strong) UIButton * gouBtn;

@end

@implementation RegisterController
- (instancetype)initWithWhere:(NSInteger)where WithIdentity:(NSString *)identity
{
    if (self = [super init]) {
        self.where = where;
        self.loginType = @"4";
        self.isAgreement = YES;
        self.identity = [NSString stringWithFormat:@"%@", identity];
    }
    return self;
}

- (instancetype)initWithWhere:(NSInteger)where WithOpenId:(NSString *)openId WithNickname:(NSString *)nickname WithAvatar:(NSString *)avatar WithLoginType:(NSString *)loginType WithIdentity:(NSString *)identity
{
    if (self = [super init]) {
        self.where = where;
        self.openId = [NSString stringWithFormat:@"%@", openId];
        self.loginType = [NSString stringWithFormat:@"%@", loginType];
        self.nickname = [NSString stringWithFormat:@"%@", nickname];
        self.avatar = [NSString stringWithFormat:@"%@", avatar];
        self.identity = [NSString stringWithFormat:@"%@", identity];
        self.isAgreement = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.ID = @"";
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
    label.text = @"注册";
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
    _textFieldPhoneNumber.placeholder = @"请输入手机号";
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
    _textFieldOne.placeholder = @"请输入6~16位密码";
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
    
    
    //沟选
    UIButton *gouBtn = [[UIButton alloc]initWithFrame:CGRectMake(23, CGRectGetMaxY(lineView3.frame)+20, 100, 15) ];
    
    gouBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [gouBtn setImage:[UIImage imageNamed:@"company_regiseter_no"] forState:UIControlStateNormal];
    [gouBtn setImage:[UIImage imageNamed:@"company_regiseter_yes"] forState:UIControlStateSelected];
   
    [gouBtn setTitle:@"填写推荐人" forState:UIControlStateNormal];
    
    gouBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [gouBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [gouBtn addTarget:self action:@selector(isSelectRegister:) forControlEvents:UIControlEventTouchUpInside];
    self.gouBtn = gouBtn;
    [self.view addSubview:gouBtn];
    
 //面板
    
    UIView *registerPanView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(gouBtn.frame)+30,  ZQ_Device_Width - 40, 100)];
    [self.view addSubview:registerPanView];
//    registerPanView.backgroundColor = [UIColor blueColor];
    self.registerPanView = registerPanView;
    
    //手机号TextField
    self.recommandTel = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, ZQ_Device_Width - 60, 30)];
    self.recommandTel.placeholder = @"请输入手机号";
    [self.recommandTel setValue:kUIColorFromRGB(0xcccccc) forKeyPath:@"placeholderLabel.textColor"];
    self.recommandTel.textAlignment = NSTextAlignmentLeft;
    self.recommandTel.borderStyle = UITextBorderStyleNone;
    self.recommandTel.font = [UIFont systemFontOfSize:15.f];
        self.recommandTel.textColor = [UIColor blackColor];
    self.recommandTel.keyboardType = UIKeyboardTypeNumberPad;
    [registerPanView addSubview:self.recommandTel];
    
    [self.recommandTel addTarget:self action:@selector(recommandTelTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineViewtel = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.recommandTel.frame), ZQ_Device_Width - 40, 2)];
    lineViewtel.backgroundColor = kUIColorFromRGB(0xcccccc);
    [registerPanView addSubview:lineViewtel];
    
    
    //添加 uiimageVIEW 和 uilabel
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineViewtel.frame)+10, 50, 50)];
    iconImageView.backgroundColor = [UIColor whiteColor];
    iconImageView.layer.cornerRadius = 25;
    iconImageView.clipsToBounds = YES;

    [registerPanView addSubview:iconImageView];
    self.iconView = iconImageView;
    
    
    UILabel *recomndLable = [[UILabel alloc]init];
    [registerPanView addSubview:recomndLable];
    recomndLable.text = @"";
    recomndLable.font = [UIFont systemFontOfSize:14];
    recomndLable.textColor = [UIColor lightGrayColor];
    self.nameLabel = recomndLable;
    
    [recomndLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(iconImageView.mas_centerY);
        make.left.mas_equalTo(iconImageView.mas_right).offset(10);
    }];

    
    
    self.registerPanView.hidden = YES;
    
    
    //点击按钮
    
    UIButton *buttonCenter = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonCenter setFrame:CGRectMake(20, CGRectGetMaxY(gouBtn.frame) + 25, ZQ_Device_Width - 40, 50)];
        [buttonCenter setTitle:@"注册" forState:UIControlStateNormal];
        [buttonCenter setTintColor:[UIColor whiteColor]];
        buttonCenter.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [[buttonCenter layer] setCornerRadius:4];
        [[buttonCenter layer] setMasksToBounds:YES];
        buttonCenter.backgroundColor = kUIColorFromRGB(0xf16156);
        [buttonCenter addTarget:self action:@selector(buttonPressedClickStatus) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buttonCenter];
    self.registerBtn = buttonCenter;
        
        //文字"同意"
        NSString *string = @"注册，即表示您同意";
        NSString *string1 = @"《易推云用户使用协议》";
        NSString *string2 = _isQiyeRegister ? @"" : @"、";
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",string, string1,string2]];
        [str2 addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0x858585) range:NSMakeRange(0, [str2 length])];
        [str2 addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0xf16156) range:NSMakeRange([string length], [string1 length])];
        UILabel *label1 = [[UILabel alloc] init];
        [label1 setFrame:CGRectMake(0, CGRectGetMaxY(self.registerBtn.frame) + 20, ZQ_Device_Width, 20)];
        label1.font = [UIFont systemFontOfSize:14];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.attributedText = str2;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreement)];
        label1.userInteractionEnabled = true;
        [label1 addGestureRecognizer:tap];
        
        [self.view addSubview:label1];
    self.shoumingLabel = label1;
  
    /// 专职协议
    if (!_isQiyeRegister) {
        NSString *fullTimeString = @"《易推云平台服务协议》";
        CGSize fullTimeSize = [NSString sizeWithString:fullTimeString andFont:[UIFont systemFontOfSize:14] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.fullTimeAgreementLabel = [[UILabel alloc] init];
        [self.fullTimeAgreementLabel setFrame:CGRectMake(55, CGRectGetMaxY(self.shoumingLabel.frame) + 5, fullTimeSize.width, 20)];
        self.fullTimeAgreementLabel.font = [UIFont systemFontOfSize:14];
        self.fullTimeAgreementLabel.text = fullTimeString;
        self.fullTimeAgreementLabel.textColor = kUIColorFromRGB(0xf16156);
        UITapGestureRecognizer *fullTimeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullTime_agreement)];
        self.fullTimeAgreementLabel.userInteractionEnabled = true;
        [self.fullTimeAgreementLabel addGestureRecognizer:fullTimeTap];
        [self.view addSubview:self.fullTimeAgreementLabel];
    }
    
    
}


#pragma mark - 推荐人的信息

-(void)recommandTelTextChange:(UITextField *)textField{
    
    
    
    if (textField.text.length == 11) {
        [self.view endEditing:YES];
        if (![NSString valiMobile:textField.text]) {
            
            
            [self showHint:@"手机号不正确"];
            return ;
            
        }else{
            
            //发起请求
            MJWeakSelf
            [SVProgressHUD showWithStatus:@"正在获取推荐人的信息.."];
            NSMutableDictionary *parm = [NSMutableDictionary dictionary];
            parm[@"phone"] = textField.text;
            [XKNetworkManager POSTToUrlString:GetInfoByPhone parameters:parm progress:^(CGFloat progress) {
                
            } success:^(id responseObject) {
                [SVProgressHUD dismiss];
                NSDictionary *resultDict = JSonDictionary;
                
//                NSLog(@"---%@----",resultDict);
                
                NSString *statusCode = [NSString stringWithFormat:@"%@",resultDict[@"errno"]];
                
                if ([statusCode isEqualToString:@"0"]) {
                    
                    //名字
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.nameLabel.text =  resultDict[@"rst"][@"user"][@"name"];
                        
                        NSString *imagepath =[NSString imagePathAddPrefix:resultDict[@"rst"][@"user"][@"avatar"]];
                       
                        [weakSelf.iconView sd_setImageWithURL:[NSURL URLWithString:imagepath]placeholderImage:[UIImage imageNamed:@"logo"]] ;
                    });
                    
                    weakSelf.ID = resultDict[@"rst"][@"user"][@"id"];
                    weakSelf.uModelid =  resultDict[@"rst"][@"user"][@"uModelid"];
                    
                    
                }else{
                    
                    [self showHint:[self statusWith:[statusCode integerValue]]];
                }
                
               
                
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
            }];
            
            
        }
        
    }
}

-(NSString *)statusWith:(NSInteger)index{
    switch (index) {
        case -1:
            return @"没有传手机号";
            break;
        case -2:
            return @"当前手机还未注册,请重新填写";
            break;
        case -3:
            return @"您输入的企业手机号,请输入个人号码";
            break;
        default:
            break;
    }
    return @"手机号错误";
    
}

#pragma mark - 推荐人的勾选状态

-(void)isSelectRegister:(UIButton *)btn{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            self.registerPanView.hidden = NO;
            self.registerBtn.frame = CGRectMake(20, CGRectGetMaxY(self.registerPanView.frame)+15, ZQ_Device_Width - 40, 50);
            self.shoumingLabel.frame =CGRectMake(0, CGRectGetMaxY(self.registerBtn.frame) + 20, ZQ_Device_Width, 20);
            if (self.fullTimeAgreementLabel && _isQiyeRegister== NO) {
                self.fullTimeAgreementLabel.y = CGRectGetMaxY(self.shoumingLabel.frame) + 5;
            }
        }];

        
    }else{
        self.ID = @"";
        self.nameLabel.text = @"";
        self.iconView.image = [UIImage imageNamed:@""];
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.registerPanView.hidden = YES;
            self.registerBtn.frame = CGRectMake(20, CGRectGetMaxY(btn.frame) + 35, ZQ_Device_Width - 40, 50);
            self.shoumingLabel.frame =CGRectMake(0, CGRectGetMaxY(self.registerBtn.frame) + 20, ZQ_Device_Width, 20);
            if (self.fullTimeAgreementLabel && _isQiyeRegister == NO) {
                self.fullTimeAgreementLabel.y = CGRectGetMaxY(self.shoumingLabel.frame) + 5;
            }
        }];
       
    }
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
                 [sender setImage:[UIImage imageNamed:@"sercert_no"] forState:UIControlStateNormal];
        _isShow = NO;
    }
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

#pragma mark - button 事件
-(void)keyboardHidden:(UIButton *)button
{
    switch (button.tag) {
        case 100:
        {
            //失去焦点
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
            break;
//        case 102://是否同意条款
//        {
//            if (self.isAgreement) {
//                self.isAgreement = NO;
//                [button setBackgroundImage:[UIImage imageNamed:@"unChoose"] forState:0];
//            }else{
//                self.isAgreement = YES;
//                [button setBackgroundImage:[UIImage imageNamed:@"choose"] forState:0];
//            }
//        }
//            break;
//        case 103://使用条款和隐私协议
//        {
//            AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
//            [self.navigationController pushViewController:agreementVC animated:YES];
//        }
//            break;
        default:
            break;
    }
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
    __weak RegisterController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = _textFieldPhoneNumber.text;
    params[@"t"] = @"1";
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=login.send_pcode"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        NSDictionary *dic = responseObject[@"rst"];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            weakSelf.code = [NSString stringWithFormat:@"%@", dic[@"code"]];
            [weakSelf showHint:@"验证码已发送，请查收"];
            
        }  else {
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

#pragma mark
#pragma mark 注册
- (void)buttonPressedClickStatus
{
    [self.textFieldCode resignFirstResponder];
    [self.textFieldOne resignFirstResponder];
    [self.textFieldPhoneNumber resignFirstResponder];
    
    if (![self.textFieldCode.text isEqualToString:self.code]) {
        [self showHint:@"验证码错误"];
        return;
    }

    
    //判断手机格式、检查是否同意协议
    if (![[NStringFormatJudgment sharedNStringFormatJudgment] registerUser:self.textFieldPhoneNumber.text andAgree:self.isAgreement]) {
        return;
    }
    //检测验证码、密码是否符合规则
    if (![[NStringFormatJudgment sharedNStringFormatJudgment] submitNewPassWordFormatJudgment:self.textFieldCode.text andOnePass:self.textFieldOne.text]) {
        return;
    }
    
    if (self.gouBtn.selected) {
        if ([self.ID isEqualToString:@""]) {
            [self showHint:@"请填写推荐人信息"];
            return ;
        }
    }

    
    if (_where == 1) {
        [self registerConfiguration];
    } else if (_where == 2) {
        [self thirdPartyRegisteConfiguration];
    }
}

- (void)registerConfiguration
{
    [self showHudInView1:self.view hint:@"加载中..."];
    __weak RegisterController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = _textFieldPhoneNumber.text;
    NSString *PsdStr = self.textFieldOne.text;
    params[@"password"] = PsdStr;
    params[@"uModelid"] = _identity;
    
    if ([self.ID isEqualToString:@""]) {
        
    }else{
        params[@"from_user_id"] = self.ID;
  
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=login.register"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
                if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            if ([_identity integerValue] == 6) {
                [MobClick event:@"registerNums_BD"];
            } else if ([_identity integerValue] == 5) {
                [MobClick event:@"registerNums_company"];
            }
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"注册成功，请问是否登录？"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     NSDictionary *dic = @{@"username":_textFieldPhoneNumber.text, @"password":_textFieldOne.text};
                     
                     
                     [[NSUserDefaults standardUserDefaults] setObject:_textFieldPhoneNumber.text forKey:LoginUsernameSave];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                     

                     
                     [weakSelf login:dic WithType:1];
                 }
             } cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试" yOffset:-200];
    }];
}

- (void)thirdPartyRegisteConfiguration
{
    [self showHudInView1:self.view hint:@"加载中..."];
    __weak RegisterController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = _textFieldPhoneNumber.text;
    params[@"password"] = _textFieldOne.text;
    params[@"wxUid"] = _openId;
//    params[@"avatar"] = _avatar;
//    params[@"realName"] = _nickname;
    params[@"uModelid"] = _identity;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=login.register"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            if ([_identity integerValue] == 6) {
                [MobClick event:@"registerNums_BD"];
            } else if ([_identity integerValue] == 5) {
                [MobClick event:@"registerNums_company"];
            }

            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"注册成功，请问是否登录？"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     NSDictionary *dic = @{@"username":_textFieldPhoneNumber.text, @"password":_textFieldOne.text};
                     [weakSelf login:dic WithType:1];
                 }
             } cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试" yOffset:-200];
    }];
}

- (void)login:(NSDictionary *)loginDic WithType:(NSInteger)type
{
    [self showHudInView1:self.view hint:@"登录中..."];
    __weak RegisterController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (type == 1) {
        params[@"username"] = loginDic[@"username"];
        params[@"password"] = loginDic[@"password"];
    } else if (type == 2) {
        params[@"user"] = [NSString stringWithFormat:@"%@", loginDic[@"uid"]];
        params[@"t"] = @"auto";
    }
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost,@"api.php?m=login"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *dic = responseObject[@"rst"];
            UserInfoModel *model = [ZQ_AppCache userInfoVo];
            [ZQ_AppCache saveUserFriendInfo:dic WithName:dic[@"uid"]];
            model.userID = [NSString stringWithFormat:@"%@", dic[@"uid"]];
            model.identity = [NSString stringWithFormat:@"%@", dic[@"uModelid"]];
            model.avatar = [NSString stringWithFormat:@"%@", dic[@"avatar"]];
            model.nickname = [NSString stringWithFormat:@"%@", dic[@"nickname"]];
            model.isSeeTel = [NSString stringWithFormat:@"%@", dic[@"isSeeTel"]];
            model.isChange = [NSString stringWithFormat:@"%@", dic[@"isChange"]];
            model.jobType = [NSString stringWithFormat:@"%@", dic[@"jobType"]];
            [ZQ_AppCache save:model];
            if ([model.identity integerValue] == 6) {
                [MobClick event:@"loginNums_BD"];
            } else if ([model.identity integerValue] == 5) {
                [MobClick event:@"loginNums_company"];
            }
            NSSet *set;
            if ([ZQ_CommonTool isEmptyArray:dic[@"tags"]]) {
                set = [[NSSet alloc] init];
            } else {
                set = [NSSet setWithArray:dic[@"tags"]];
            }
            [JPUSHService setTags:set alias:model.userID callbackSelector:nil object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            [ZQ_CallMethod refreshInterface];
            
            //登录环信
            [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"%@", dic[@"uid"]] password:[NSString stringWithFormat:@"%@", dic[@"uid"]] completion:^(NSString *aUsername, EMError *aError) {
                if (!aError) {
                    [USERDEFALUTS setInteger:0 forKey:@"pushMessageCount"];
                    [USERDEFALUTS synchronize];
                    [ZQ_CallMethod setupNewMessageBoxCount];
                }
            }];
        } else {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"登录失败，请问是否重新登录"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     [weakSelf login:loginDic WithType:type];
                 } else {
                     [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                 }
             } cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"登录失败，请问是否重新登录"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 [weakSelf login:loginDic WithType:type];
             } else {
                 [weakSelf.navigationController popToRootViewControllerAnimated:YES];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
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
    } else if (textField == self.textFieldOne){
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
    [self buttonPressedClickStatus];
    return YES;
}

#pragma mark -- 用户协议
- (void)agreement{
    AgreementViewController *web = [[AgreementViewController alloc] init];
    web.isUserUse = YES;
    [self.navigationController pushViewController:web animated:true];
    
}

- (void)fullTime_agreement{
    AgreementViewController *web = [[AgreementViewController alloc] init];
    web.isUserUse = NO;
    [self.navigationController pushViewController:web animated:true];
    
}
@end
