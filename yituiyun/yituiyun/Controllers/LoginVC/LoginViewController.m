//
//  LoginViewController.m
//  yituiyun
//
//  Created by NIT on 15-3-11.
//  Copyright (c) 2015年 NIT. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetViewController.h"
#import "RegisterController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "ZQImageAndLabelButton.h"
#import "NSString+QJAddition.h"


#import <ShareSDK/ShareSDK.h>
#import "ThirdPartyChooseController.h"
#import "IdentityChooseViewController.h"
#import "NSString+LHKExtension.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, assign) NSInteger where;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *loginType;
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) BOOL isShow;
@end

#define kButtonTag    10000

@implementation LoginViewController
- (instancetype)init:(NSInteger)where
{
    self = [super init];
    if (self) {
        self.where = where;
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    
    [self setupNav];
    
    [self markView];
    
    
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUsernameSave];
    
    if (phone.length>0) {
        self.phoneNumberTextField.text = phone;
    }
}

- (void)setupNav
{
    
    [self.navigationController.navigationBar setTranslucent:YES];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    label.text = @"登录";
//    label.textColor = [UIColor whiteColor];
//    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
//    label.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = label;
    if (_where == 2) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"backRed" selectedImage:@"backRed" target:self action:@selector(leftBtnDidClick)];
    }
}

- (void)markView
{
    self.view.backgroundColor = kUIColorFromRGB(0xffffff);
    //点击键盘消失
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressedKeybordHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指
    singleFingerOne.numberOfTapsRequired = 1;    //tap次数
    singleFingerOne.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleFingerOne];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width/2 - ZQ_Device_Width/4/2, ZQ_Device_Width/4, ZQ_Device_Width/4, ZQ_Device_Width/4)];
    iconView.image = [UIImage imageNamed:@"icon"];
    iconView.layer.borderWidth = 1.0f;
    iconView.layer.borderColor = kUIColorFromRGB(0xf16156).CGColor;
    [[iconView layer] setCornerRadius:ZQ_Device_Width/8];
    [[iconView layer] setMasksToBounds:YES];
    [self.view addSubview:iconView];
    
    //手机号TextField
    self.phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(iconView.frame) + 30, ZQ_Device_Width - 60, 30)];
    _phoneNumberTextField.placeholder = @"注册所填手机号";
    [_phoneNumberTextField setValue:kUIColorFromRGB(0xcccccc) forKeyPath:@"placeholderLabel.textColor"];
    _phoneNumberTextField.textAlignment = NSTextAlignmentLeft;
    _phoneNumberTextField.borderStyle = UITextBorderStyleNone;
    _phoneNumberTextField.font = [UIFont systemFontOfSize:15.f];
    _phoneNumberTextField.delegate = self;
    _phoneNumberTextField.textColor = [UIColor blackColor];
    _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneNumberTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_phoneNumberTextField.frame), ZQ_Device_Width - 40, 2)];
    lineView.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView];
    
    //密码TextField
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(lineView.frame) + 30, ZQ_Device_Width - 70, 30)];
    _passwordTextField.placeholder = @"密码";
    [_passwordTextField setValue:kUIColorFromRGB(0xcccccc) forKeyPath:@"placeholderLabel.textColor"];
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.font = [UIFont systemFontOfSize:15.f];
    _passwordTextField.delegate = self;
//    _passwordTextField.clearsOnBeginEditing = YES;       //再次编辑的时候，清空内部文字
    _passwordTextField.secureTextEntry = YES;            //使内容以保密圆点方式显示
    [_passwordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [_passwordTextField setReturnKeyType:UIReturnKeyDone];
    _passwordTextField.textColor = [UIColor blackColor];
    [self.view addSubview:_passwordTextField];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_passwordTextField.frame), ZQ_Device_Width - 40, 2)];
    lineView1.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView1];
    
    UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eyeBtn.frame = CGRectMake(ZQ_Device_Width - 60, CGRectGetMaxY(lineView1.frame) - 30-4, 35, 35);

    
    [eyeBtn setImage:[UIImage imageNamed:@"sercert_no"] forState:UIControlStateNormal];
    [eyeBtn addTarget:self action:@selector(eyeBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:eyeBtn];
    
    //登录button
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(20, CGRectGetMaxY(lineView1.frame) + 20, self.view.frame.size.width - 40, 50);
    loginButton.tag = kButtonTag;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTintColor:kUIColorFromRGB(0xffffff)];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [[loginButton layer] setCornerRadius:4];
    [[loginButton layer] setMasksToBounds:YES];
    loginButton.backgroundColor = kUIColorFromRGB(0xf16156);
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(ZQ_Device_Width/2-1, CGRectGetMaxY(loginButton.frame) + 22, 2, 15)];
    lineView2.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView2];
    
    //忘记密码Button
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(ZQ_Device_Width/2 - 121, CGRectGetMaxY(loginButton.frame) + 10, 120, 40);
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [forgetButton setTitleColor:kUIColorFromRGB(0x888888) forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgotPasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    
    //立即注册Button
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    registerButton.frame = CGRectMake(ZQ_Device_Width/2+1, CGRectGetMaxY(loginButton.frame) + 10, 120, 40);
    [registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [registerButton setTitleColor:kUIColorFromRGB(0xf16156) forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(ZQ_Device_Width/2-1, ZQ_Device_Height - 53, 2, 15)];
    lineView3.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView3];
    
    ZQImageAndLabelButton *weiBtn = [[ZQImageAndLabelButton alloc] initWithFrame:CGRectMake(0, ZQ_Device_Height - 70, ZQ_Device_Width/2, 50)];
    weiBtn.imageV.frame = ZQ_RECT_CREATE(weiBtn.width/9*2, 10, 30, 30);
    weiBtn.imageV.image = [UIImage imageNamed:@"weixin"];
    weiBtn.label.text = @"微信登录";
    weiBtn.label.frame = ZQ_RECT_CREATE(weiBtn.width/9*2 + 37, 10, weiBtn.width - weiBtn.width/9*2 - 37, 30);
    weiBtn.label.textColor = kUIColorFromRGB(0x888888);
    weiBtn.label.font = [UIFont systemFontOfSize:15];
    [weiBtn addTarget:self action:@selector(thirdPartyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiBtn];
    
    UIButton *seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seeBtn.frame = CGRectMake(ZQ_Device_Width/2 + 1, ZQ_Device_Height - 70, ZQ_Device_Width/2, 50);
    [seeBtn setTitle:@"随便看看" forState:UIControlStateNormal];
    seeBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [seeBtn setTitleColor:kUIColorFromRGB(0x888888) forState:UIControlStateNormal];
    [seeBtn addTarget:self action:@selector(leftBtnDidClick) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:seeBtn];
    
}

- (void)eyeBtnClick:(UIButton *)sender
{
    _passwordTextField.secureTextEntry = _isShow;

    if (_isShow == NO) {
        _isShow = YES;
        [sender setImage:[UIImage imageNamed:@"sercert_yes"] forState:UIControlStateNormal];

    } else {
        NSString *text = _passwordTextField.text;
        _passwordTextField.text = @"";
        _passwordTextField.text = text;
        [sender setImage:[UIImage imageNamed:@"sercert_no"] forState:UIControlStateNormal];

        _isShow = NO;
    }
}

-(void)buttonPressedKeybordHidden
{
    [_phoneNumberTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)leftBtnDidClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)textFieldresignFirstResponder
{
    [_phoneNumberTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)registerButtonClick
{
    [self textFieldresignFirstResponder];
    IdentityChooseViewController *vc = [[IdentityChooseViewController alloc] initWithWhere:1];
    pushToControllerWithAnimated(vc)
}

- (void)forgotPasswordClick
{
    [self textFieldresignFirstResponder];
    ForgetViewController *forgetVC = [[ForgetViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)loginButtonClick:(UIButton *)button
{
    [self actionLogin];
}

- (void)actionLogin
{
    [self textFieldresignFirstResponder];
    
    
    if (_phoneNumberTextField.text.length == 0 || _phoneNumberTextField ==nil) {
        ALERT_MSG(@"提示",@"手机号不能为空");
        return ;
    }else if ([NSString valiMobile:_phoneNumberTextField.text]) {
        
    }else{
            ALERT_MSG(@"提示",@"输入的手机号不正确");
        return ;
    }
    
    if (![ZQ_CommonTool isEmpty:_passwordTextField.text]) {
        if (![ZQ_CommonTool isValidate:kPredicatePassword valueString:_passwordTextField.text]) {
            ALERT_MSG(@"提示",@"您输入的密码格式不正确(6-16位，包含数字、字母，不包含符号)");
            return;
        }
    } else {
        ALERT_MSG(@"提示",@"请您输入密码");
        return;
    }
    
    if ([[Reachability reachabilityForInternetConnection] isReachable]){
      
        [self loginLocalServer];
    } else {
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"当前网络不可用，请检查您的网络设置。"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 [self loginLocalServer];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)loginLocalServer
{
    [self.view endEditing:true];
    [self showHudInView1:self.view hint:@"登录中..."];
    __weak LoginViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = _phoneNumberTextField.text;
    NSString *PsdStr = self.passwordTextField.text;
    params[@"password"] = PsdStr;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=login"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            
            //
            [[NSUserDefaults standardUserDefaults] setObject:_phoneNumberTextField.text forKey:LoginUsernameSave];
            [[NSUserDefaults standardUserDefaults] synchronize];
            

            
            
            [weakSelf loginConfiguration:responseObject[@"rst"]];
            
            
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"登录失败，请问是否重新登录"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 [self loginLocalServer];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
    }];
}

#pragma mark - 添加配置
- (void)loginConfiguration:(NSDictionary *)dic
{
    
    
    
    
    if (_where == 1) {
        MainViewController *mainVC = [[MainViewController alloc] init];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.viewController = mainVC;
        appDelegate.window.rootViewController = mainVC;
    } else {
        if ([dic[@"errno"] isEqualToString:@"4"]) {
            ThirdPartyChooseController *registerVC = [[ThirdPartyChooseController alloc] initWithWithOpenId:[NSString stringWithFormat:@"%@", _openId] WithNickname:_nickname WithAvatar:_headimgurl WithLoginType:_loginType];
            [self.navigationController pushViewController:registerVC animated:YES];
        } else {
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
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    
    if(textField == self.phoneNumberTextField){
        if(proposedNewLength > 11){
            return NO;
        }
        return YES;
    }else if (textField == self.passwordTextField){
        if(proposedNewLength > 20){
            return NO;
        }
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self actionLogin];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == _phoneNumberTextField) {
        _passwordTextField.text = @"";
    }
    
    return YES;
}

- (void)thirdPartyButtonClick
{
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    
    __weak LoginViewController *weakSelf = self;
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess) {
             
             

             
             weakSelf.openId = [NSString stringWithFormat:@"%@", user.uid];
             weakSelf.headimgurl = [NSString stringWithFormat:@"%@", user.icon];
             weakSelf.nickname = [NSString stringWithFormat:@"%@", user.nickname];
             weakSelf.loginType = @"1";
             [weakSelf thirdPartyLoginLocalServer:user WithLoginType:@"1"];
         } else {
             [weakSelf showHint:@"获取微信信息失败"];
         }
     }];
}

- (void)thirdPartyLoginLocalServer:(SSDKUser *)user WithLoginType:(NSString *)loginType
{
    [self showHudInView1:self.view hint:@"登录中..."];
    __weak LoginViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([_loginType integerValue] == 1) {
        params[@"wxUid"] = _openId;
        params[@"t"] = @"wx";
    }
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=login"];
    
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        
        
        
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            [weakSelf loginConfiguration:responseObject[@"rst"]];
        } else if ([responseObject[@"errno"] isEqualToString:@"4"]) {
            [weakSelf loginConfiguration:responseObject];
        } else {
            [ZQ_UIAlertView showMessage:responseObject[@"errmsg"] cancelTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"登录失败，请问是否重新登录"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 [weakSelf thirdPartyLoginLocalServer:user WithLoginType:loginType];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////点击登陆后的操作
//- (void)loginWithUsername:(NSString *)username password:(NSString *)password
//{
//    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
//    //异步登陆账号
//    __weak typeof(self) weakself = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakself hideHud];
//            if (!error) {
//                //设置是否自动登录
//                [[EMClient sharedClient].options setIsAutoLogin:YES];
//                
//                //获取数据库中数据
//                //                [MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    [[EMClient sharedClient] dataMigrationTo3];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [[ChatDemoHelper shareHelper] asyncGroupFromServer];
//                        [[ChatDemoHelper shareHelper] asyncConversationFromDB];
//                        [[ChatDemoHelper shareHelper] asyncPushOptions];
//                        //                        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
//                        //发送自动登陆状态通知
//                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
//                        
//                        //保存最近一次登录用户名
//                        //                        [weakself saveLastLoginUsername];
//                    });
//                });
//            } else {
//                switch (error.code)
//                {
//                        //                    case EMErrorNotFound:
//                        //                        TTAlertNoTitle(error.errorDescription);
//                        //                        break;
//                    case EMErrorNetworkUnavailable:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
//                        break;
//                    case EMErrorServerNotReachable:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
//                        break;
//                    case EMErrorUserAuthenticationFailed:
//                        TTAlertNoTitle(error.errorDescription);
//                        break;
//                    case EMErrorServerTimeout:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
//                        break;
//                    default:
//                        TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
//                        break;
//                }
//            }
//        });
//    });
//}


@end
