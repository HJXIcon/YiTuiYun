//
//  ECodeLoginViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/5.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ECodeLoginViewController.h"
#import "ERegisterViewController.h"
#import "ELoginViewModel.h"
#import <WXApi.h>
#import "EUserModel.h"

@interface ECodeLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UITextField *codeTextF;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *psdLoginBtn;
@property (nonatomic, strong) UIButton *wxLoginBtn;
@property (nonatomic, strong) UIButton *getCodeBtn;

@property(strong,nonatomic) NSTimer *timer;
/** 时间 */
@property (nonatomic, assign) int time;
@end

@implementation ECodeLoginViewController


#pragma mark - *** cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
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
- (void)setupNav{
    self.navigationItem.title = @"验证码登录";
}
- (void)setupUI{
    self.iconImageView = [JXFactoryTool creatImageView:CGRectZero image:[UIImage imageNamed:@"touxiang"]];
    [self.view addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(E_RealWidth(80));
        make.height.mas_equalTo(E_RealHeight(80));
        make.top.mas_equalTo(self.view).offset(E_RealHeight(28) + E_StatusBarAndNavigationBarHeight);
        make.centerX.mas_equalTo(self.view);
    }];
    
    
    // 账号
    UILabel *phoneLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(18)] textColor:[UIColor colorWithHexString:@"#4c4c4c"] text:@"手机号:" textAlignment:0];
    [self.view addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(E_RealHeight(42));
        make.left.mas_equalTo(E_RealWidth(38));
    }];
    
    self.phoneTextF = [[UITextField alloc]init];
    self.phoneTextF.placeholder = @"请输入你的手机号";
    self.phoneTextF.textColor = [UIColor colorWithHexString:@"ffbf00"];
    self.phoneTextF.delegate = self;
    self.phoneTextF.font = [UIFont systemFontOfSize:E_FontRadio(16)];
    if (!kStringIsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:E_MobileKey])) {
        self.phoneTextF.text = [[NSUserDefaults standardUserDefaults]objectForKey:E_MobileKey];
    }
    [self.view addSubview:self.phoneTextF];
    [self.phoneTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel.mas_right).offset(E_RealWidth(33));
        make.top.mas_equalTo(phoneLabel);
    }];
    
    UIView *lin1 = [[UIView alloc]init];
    lin1.backgroundColor = [UIColor colorWithHexString:@"#cecece"];
    [self.view addSubview:lin1];
    [lin1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.phoneTextF.mas_bottom).offset(E_RealHeight(11));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(E_RealWidth(596/2));
    }];
    
    // 验证码
    UILabel *psdLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(18)] textColor:[UIColor colorWithHexString:@"#4c4c4c"] text:@"验证码:" textAlignment:0];
    [self.view addSubview:psdLabel];
    [psdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneLabel.mas_bottom).offset(E_RealHeight(29));
        make.left.mas_equalTo(phoneLabel);
    }];
    
    self.codeTextF = [[UITextField alloc]init];
    self.codeTextF.placeholder = @"请输入验证码";
    self.codeTextF.font = [UIFont systemFontOfSize:E_FontRadio(16)];
    self.codeTextF.textColor = [UIColor colorWithHexString:@"ffbf00"];
    [self.view addSubview:self.codeTextF];
    [self.codeTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(psdLabel.mas_right).offset(E_RealWidth(33));
        make.top.mas_equalTo(psdLabel);
    }];
    
    UIView *lin2 = [[UIView alloc]init];
    lin2.backgroundColor = [UIColor colorWithHexString:@"#cecece"];
    [self.view addSubview:lin2];
    [lin2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.codeTextF.mas_bottom).offset(E_RealHeight(11));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(E_RealWidth(596/2));
    }];
    
    /// 获取验证码
    self.getCodeBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(15)] normalColor:[UIColor colorWithHexString:@"#ffbf00"] selectColor:[UIColor colorWithHexString:@"#ffbf00"] title:@"获取验证码" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(getCodeAction:)];
    self.getCodeBtn.borderWidth = 1;
    self.getCodeBtn.borderColor = [UIColor colorWithHexString:@"#ffcd38"].CGColor;
    self.getCodeBtn.cornerRadius = 3;
    CGSize getCodeSize = CGSizeMake(E_RealWidth(87), E_RealHeight(35));
    [self.view addSubview:self.getCodeBtn];
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(lin2.mas_top).offset(-E_RealHeight(4));
        make.right.mas_equalTo(lin2);
        make.size.mas_equalTo(getCodeSize);
    }];
    
    
    //  注册
    self.registerBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] normalColor:[UIColor colorWithHexString:@"#4c4c4c"] selectColor:nil title:@"注册" nornamlImageName:nil selectImageName:nil textAlignment:0 target:self action:@selector(registerAction)];
    [self.view addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(lin2);
        make.top.mas_equalTo(psdLabel.mas_bottom).offset(E_RealHeight(29));
    }];
    
    // 登录 & 注册
    UIImage *nornamlImage = [UIImage imageGradientWithFrame:CGRectMake(0, 0, E_RealWidth(300), E_RealHeight(50)) colors:@[[UIColor colorWithHexString:@"#ffce3d"],[UIColor colorWithHexString:@"#ffbf00"]] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:nornamlImage forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
    self.loginBtn.cornerRadius = E_RealHeight(25);
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lin2.mas_bottom).offset(E_RealHeight(57));
        make.width.mas_equalTo(E_RealWidth(300));
        make.height.mas_equalTo(E_RealHeight(50));
        make.centerX.mas_equalTo(self.view);
    }];
    
    
    self.psdLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.psdLoginBtn addTarget:self action:@selector(codeLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.psdLoginBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
    [self.psdLoginBtn setTitleColor:[UIColor colorWithHexString:@"#ffbf00"] forState:UIControlStateNormal];
    [self.psdLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.psdLoginBtn.cornerRadius = E_RealHeight(25);
    self.psdLoginBtn.borderWidth = 1;
    self.psdLoginBtn.borderColor = [UIColor colorWithHexString:@"#ffcd38"].CGColor;
    [self.psdLoginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.psdLoginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
    [self.view addSubview:self.psdLoginBtn];
    [self.psdLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(E_RealHeight(24));
        make.width.mas_equalTo(E_RealWidth(300));
        make.height.mas_equalTo(E_RealHeight(50));
        make.centerX.mas_equalTo(self.view);
    }];
    
    
    CGFloat thirdSpace = E_RealHeight(78);
    if (iPhone5s) {
        thirdSpace = E_RealHeight(68);
    }
    // 第三方登录
    UILabel *thirdLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor colorWithHexString:@"#3c3c3c"] text:@"第三方登录" textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:thirdLabel];
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.psdLoginBtn.mas_bottom).offset(thirdSpace);
    }];
    
    UIView *leftLine = [[UIView alloc]init];
    leftLine.backgroundColor = [UIColor colorWithHexString:@"#cecece"];
    [self.view addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(thirdLabel);
        make.width.mas_equalTo(E_RealWidth(93));
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(thirdLabel.mas_left).offset(-E_RealWidth(18));
    }];
    
    UIView *rightLine = [[UIView alloc]init];
    rightLine.backgroundColor = [UIColor colorWithHexString:@"#cecece"];
    [self.view addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(thirdLabel);
        make.width.mas_equalTo(E_RealWidth(93));
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(thirdLabel.mas_right).offset(E_RealWidth(18));
    }];
    
    self.wxLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.wxLoginBtn setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [self.wxLoginBtn addTarget:self action:@selector(wxLoginAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.wxLoginBtn];
    [self.wxLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.height.mas_equalTo(E_RealWidth(35));
        make.top.mas_equalTo(thirdLabel.mas_bottom).offset(E_RealHeight(24));
    }];
    
    UILabel *wxLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor colorWithHexString:@"#3c3c3c"] text:@"微信" textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:wxLabel];
    [wxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.wxLoginBtn.mas_bottom).offset(E_RealHeight(8));
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

- (void)wxLoginAtion{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)codeLoginAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerAction{
    [self.navigationController pushViewController:[[ERegisterViewController alloc]init] animated:YES];
}

- (void)leftAction{
    JXLog(@"leftAction -- ");
}

- (void)loginAction{
    if (kStringIsEmpty(self.codeTextF.text)) {
        [self showHint:@"请输入验证码"];
        return;
    }
    
    [ELoginViewModel loginWithMobile:self.phoneTextF.text verifyCode:self.codeTextF.text completion:^(EUserModel *model,BOOL isSuccess) {
        if (isSuccess) {
            [EUserInfoManager saveUserInfo:model];
            [EControllerManger turnToMainController];
        }
        else{
            _time = 0;
            
        }
       
        
    }];
    
}

// 第三方登录
//- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
//{
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
//
//        UMSocialUserInfoResponse *resp = result;
//
//        // 第三方登录数据(为空表示平台未提供)
//        // 授权数据
//        NSLog(@" uid: %@", resp.uid);
//        NSLog(@" openid: %@", resp.openid);
//        NSLog(@" accessToken: %@", resp.accessToken);
//        NSLog(@" refreshToken: %@", resp.refreshToken);
//        NSLog(@" expiration: %@", resp.expiration);
//
//        // 用户数据
//        NSLog(@" name: %@", resp.name);
//        NSLog(@" iconurl: %@", resp.iconurl);
//        NSLog(@" gender: %@", resp.unionGender);
//
//        // 第三方平台SDK原始数据
//        NSLog(@" originalResponse: %@", resp.originalResponse);
//    }];
//}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    // >>>>> 定制自己的分享面板预定义平台
//    // 以下方法可设置平台顺序
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sms)]];
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        // 根据获取的platformType确定所选平台进行下一步操作
//        [self shareWebPageToPlatformType:platformType];
//    }];
//
//}

/// 第三方分享
//- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    //创建网页内容对象
//    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
//    //设置网页地址
//    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
//    
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//                
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
//        }
//        
//    }];
//}


#pragma mark - *** UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phoneTextF) {
        
        if (range.location >= 11) return NO;
    }
    
    return YES;
    
}

@end
