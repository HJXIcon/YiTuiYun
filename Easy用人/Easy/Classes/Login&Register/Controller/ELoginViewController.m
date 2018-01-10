//
//  ELoginViewController.m
//  Easy
//
//  Created by yituiyun on 2017/11/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ELoginViewController.h"
#import "ERegisterViewController.h"
#import "EGetBackPsdViewController.h"
#import "ECodeLoginViewController.h"
#import "ELoginViewModel.h"
#import "EThirdLoginBindViewController.h"
#import <WXApi.h>

@interface ELoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UITextField *psdTextF;
@property (nonatomic, strong) UIButton *forgetBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *codeLoginBtn;
@property (nonatomic, strong) UIButton *wxLoginBtn;
@end

@implementation ELoginViewController

#pragma mark - *** cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxDidLoginAction:) name:WechatDidLoginNotificationName object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WechatDidLoginNotificationName object:nil];
}

#pragma mark - *** UI
- (void)setupNav{
    self.navigationItem.title = @"登录";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem item:[UIImage imageNamed:@"jiantou"] selImage:[UIImage imageNamed:@"jiantou"] target:self action:@selector(leftAction)];
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
    UILabel *phoneLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(18)] textColor:[UIColor colorWithHexString:@"#4c4c4c"] text:@"账号:" textAlignment:0];
    [self.view addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(E_RealHeight(42));
        make.left.mas_equalTo(E_RealWidth(38));
    }];
    
    self.phoneTextF = [[UITextField alloc]init];
    self.phoneTextF.placeholder = @"请输入你的账号";
    self.phoneTextF.textColor = [UIColor colorWithHexString:@"ffbf00"];
    self.phoneTextF.delegate = self;
    self.phoneTextF.font = [UIFont systemFontOfSize:E_FontRadio(16)];
    [self.view addSubview:self.phoneTextF];
    if (!kStringIsEmpty([[NSUserDefaults standardUserDefaults]objectForKey:E_MobileKey])) {
        self.phoneTextF.text = [[NSUserDefaults standardUserDefaults]objectForKey:E_MobileKey];
    }
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
    
    // 密码
    UILabel *psdLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(18)] textColor:[UIColor colorWithHexString:@"#4c4c4c"] text:@"密码:" textAlignment:0];
    [self.view addSubview:psdLabel];
    [psdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneLabel.mas_bottom).offset(E_RealHeight(29));
        make.left.mas_equalTo(phoneLabel);
    }];
    
    self.psdTextF = [[UITextField alloc]init];
    self.psdTextF.placeholder = @"6-20位数字或者字母";
    self.psdTextF.font = [UIFont systemFontOfSize:E_FontRadio(16)];
    self.psdTextF.secureTextEntry = YES;
    self.psdTextF.textColor = [UIColor colorWithHexString:@"ffbf00"];
    self.psdTextF.keyboardType = UIKeyboardTypeNamePhonePad;
    self.psdTextF.secureTextEntry = YES;
    [self.view addSubview:self.psdTextF];
    [self.psdTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(psdLabel.mas_right).offset(E_RealWidth(33));
        make.top.mas_equalTo(psdLabel);
    }];
    
    UIView *lin2 = [[UIView alloc]init];
    lin2.backgroundColor = [UIColor colorWithHexString:@"#cecece"];
    [self.view addSubview:lin2];
    [lin2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.psdTextF.mas_bottom).offset(E_RealHeight(11));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(E_RealWidth(596/2));
    }];
    
    
    // 忘记密码 & 注册
    self.forgetBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] normalColor:[UIColor colorWithHexString:@"#4c4c4c"] selectColor:nil title:@"忘记密码?" nornamlImageName:nil selectImageName:nil textAlignment:0 target:self action:@selector(fogetAction)];
    [self.view addSubview:self.forgetBtn];
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(psdLabel);
        make.top.mas_equalTo(psdLabel.mas_bottom).offset(E_RealHeight(29));
    }];
    
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
    
    
    self.codeLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeLoginBtn addTarget:self action:@selector(codeLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.codeLoginBtn setTitle:@"动态密码登录" forState:UIControlStateNormal];
    [self.codeLoginBtn setTitleColor:[UIColor colorWithHexString:@"#ffbf00"] forState:UIControlStateNormal];
    [self.codeLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.codeLoginBtn.cornerRadius = E_RealHeight(25);
    self.codeLoginBtn.borderWidth = 1;
    self.codeLoginBtn.borderColor = [UIColor colorWithHexString:@"#ffcd38"].CGColor;
    [self.codeLoginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.codeLoginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffba00"]] forState:UIControlStateHighlighted];
    [self.view addSubview:self.codeLoginBtn];
    [self.codeLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.mas_equalTo(self.codeLoginBtn.mas_bottom).offset(thirdSpace);
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
- (void)wxDidLoginAction:(NSNotification *)noti{
    JXWeak(self);
    NSDictionary *dic = noti.userInfo;
    [ELoginViewModel authorizedLoginWithCode:dic[@"code"] completion:^(BOOL isAuthorized,NSString *wxUid) {
        
        if (isAuthorized) {
            [EControllerManger turnToMainController];
            
        }else{
            EThirdLoginBindViewController *vc = [[EThirdLoginBindViewController alloc]init];
            vc.wxUid = wxUid;
            [weakself.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}

- (void)wxLoginAtion{
    
    if ([WXApi isWXAppInstalled]) {
        //构造SendAuthReq结构体
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }

}

- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)codeLoginAction{
    [self.navigationController pushViewController:[[ECodeLoginViewController alloc]init] animated:YES];
}
- (void)registerAction{
    [self.navigationController pushViewController:[[ERegisterViewController alloc]init] animated:YES];
}

- (void)fogetAction{
    [self.navigationController pushViewController:[[EGetBackPsdViewController alloc]init] animated:YES];
}

- (void)loginAction{
    
    
    if (kStringIsEmpty(self.phoneTextF.text)) {
        [self showHint:@"请输入手机号"];
        return;
    }
    if (kStringIsEmpty(self.psdTextF.text)) {
        [self showHint:@"请输入密码"];
        return;
    }
    
    [ELoginViewModel loginWithMobile:self.phoneTextF.text password:self.psdTextF.text completion:^(EUserModel *model) {
        
     [EUserInfoManager saveUserInfo:model];
     [EControllerManger turnToMainController];
    }];
}

/// 第三方登录
//- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
//{
//    JXWeak(self);
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
//
//        UMSocialUserInfoResponse *resp = result;
//
//        [ELoginViewModel authorizedLoginWithWxUid:resp.openid completion:^(BOOL isAuthorized) {
//
//            if (isAuthorized) {
//                [EControllerManger turnToMainController];
//
//            }else{
//                EThirdLoginBindViewController *vc = [[EThirdLoginBindViewController alloc]init];
//                vc.wxUid = resp.openid;
//                [weakself.navigationController pushViewController:vc animated:YES];
//            }
//
//        }];
//
//
//
//        // 第三方登录数据(为空表示平台未提供)
//        // 授权数据
//        JXLog(@" uid: %@", resp.uid);
//        JXLog(@" openid: %@", resp.openid);
//        JXLog(@" accessToken: %@", resp.accessToken);
//        JXLog(@" refreshToken: %@", resp.refreshToken);
//        JXLog(@" expiration: %@", resp.expiration);
//
//        // 用户数据
//        JXLog(@" name: %@", resp.name);
//        JXLog(@" iconurl: %@", resp.iconurl);
//        JXLog(@" gender: %@", resp.unionGender);
//
//        // 第三方平台SDK原始数据
//        JXLog(@" originalResponse: %@", resp.originalResponse);
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
