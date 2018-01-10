//
//  AssociateViewController.m
//  yituiyun
//
//  Created by NIT on 15-3-11.
//  Copyright (c) 2015年 NIT. All rights reserved.
//

#import "AssociateViewController.h"

@interface AssociateViewController ()<UITextFieldDelegate>
@property(strong,nonatomic) UITextField *textFieldPhoneNumber;    //输手机号
@property(strong,nonatomic) UITextField *textFieldOne;      //输入密码
@property(assign,nonatomic) BOOL isShow;                    //密码是否显示

@property(copy,nonatomic) NSString *openId;
@property(copy,nonatomic) NSString *loginType;
@property(copy,nonatomic) NSString *nickname;
@property(copy,nonatomic) NSString *avatar;

@end

@implementation AssociateViewController
- (instancetype)initWithWithOpenId:(NSString *)openId WithNickname:(NSString *)nickname WithAvatar:(NSString *)avatar WithLoginType:(NSString *)loginType
{
    if (self = [super init]) {
        self.openId = [NSString stringWithFormat:@"%@", openId];
        self.loginType = [NSString stringWithFormat:@"%@", loginType];
        self.nickname = [NSString stringWithFormat:@"%@", nickname];
        self.avatar = [NSString stringWithFormat:@"%@", avatar];
    }
    return self;
}

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
    label.text = @"关联账号";
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
    self.textFieldPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(30, 104, ZQ_Device_Width - 60, 30)];
    _textFieldPhoneNumber.placeholder = @"注册所填手机号";
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
    
    //密码TextField
    self.textFieldOne = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(lineView.frame) + 30, ZQ_Device_Width - 70, 30)];
    _textFieldOne.placeholder = @"密码";
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
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_textFieldOne.frame), ZQ_Device_Width - 40, 2)];
    lineView1.backgroundColor = kUIColorFromRGB(0xcccccc);
    [self.view addSubview:lineView1];
    
    UIButton *eyeBtn = [[UIButton alloc]init];
    eyeBtn.frame = CGRectMake(ZQ_Device_Width - 60, CGRectGetMaxY(lineView1.frame) - 30, 25, 25);
       [eyeBtn setImage:[UIImage imageNamed:@"sercert_no"] forState:UIControlStateNormal];
    [eyeBtn addTarget:self action:@selector(eyeBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:eyeBtn];
    
    //登录button
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(20, CGRectGetMaxY(lineView1.frame) + 30, self.view.frame.size.width - 40, 50);
    [loginButton setTitle:@"立即关联" forState:UIControlStateNormal];
    [loginButton setTintColor:kUIColorFromRGB(0xffffff)];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [[loginButton layer] setCornerRadius:4];
    [[loginButton layer] setMasksToBounds:YES];
    loginButton.backgroundColor = kUIColorFromRGB(0xf16156);
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(loginButton.frame) + 30, ZQ_Device_Width, 30)];
    label.text = @"使用注册手机号进行账号关联";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = kUIColorFromRGB(0x808080);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
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
                  [sender setImage:[UIImage imageNamed:@"sercert_no"] forState:UIControlStateNormal];
        NSString *text = _textFieldOne.text;
        _textFieldOne.text = @"";
        _textFieldOne.text = text;
        _isShow = NO;
    }
}


//键盘隐藏
-(void)buttonPressedKeybordHidden
{
    [self.textFieldPhoneNumber resignFirstResponder];
    [self.textFieldOne resignFirstResponder];

}

- (void)loginButtonClick
{
    [self buttonPressedKeybordHidden];
    
    [self showHudInView1:self.view hint:@"登录中..."];
    __weak AssociateViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = _textFieldPhoneNumber.text;
    params[@"password"] = _textFieldOne.text;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=login"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
            NSDictionary *subDic = responseObject[@"rst"];
            if ([subDic[@"uModelid"] integerValue] == 5) {
                [ZQ_UIAlertView showMessage:@"企业账号暂时不支持绑定微信账号" cancelTitle:@"确定"];
            } else if ([subDic[@"uModelid"] integerValue] == 6) {
                [weakSelf updateInformation:subDic];
            }
        } else {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"关联失败，请问是否重试？"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     [weakSelf loginButtonClick];
                 }
             } cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"关联失败，请问是否重试？"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 [weakSelf loginButtonClick];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    }];
    
}

- (void)updateInformation:(NSDictionary *)dic {
    __weak AssociateViewController *weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [NSString stringWithFormat:@"%@", dic[@"uid"]];
    params[@"uModelid"] = [NSString stringWithFormat:@"%@", dic[@"uModelid"]];
    params[@"wxUid"] = _openId;
    NSString *URL = [NSString stringWithFormat:@"%@%@", kHost, @"api.php?m=my.saveInfo"];
    [HFRequest requestWithUrl:URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        if ([responseObject[@"errno"] isEqualToString:@"0"]) {
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
            NSError *error;
            error = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"%@", dic[@"uid"]] password:[NSString stringWithFormat:@"%@", dic[@"uid"]]];
            if (!error) {
                [USERDEFALUTS setInteger:0 forKey:@"pushMessageCount"];
                [USERDEFALUTS synchronize];
                [ZQ_CallMethod setupNewMessageBoxCount];
            }
        } else {
            [WCAlertView showAlertWithTitle:@"提示"
                                    message:@"关联失败，请问是否重试？"
                         customizationBlock:^(WCAlertView *alertView) {
                             
                         } completionBlock:
             ^(NSUInteger buttonIndex, WCAlertView *alertView) {
                 if (buttonIndex == 1) {
                     [weakSelf updateInformation:dic];
                 }
             } cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"关联失败，请问是否重试？"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 [weakSelf updateInformation:dic];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
