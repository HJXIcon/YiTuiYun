//
//  IdentityChooseViewController.m
//  yituiyun
//
//  Created by 张强 on 16/10/17.
//  Copyright © 2016年 张强. All rights reserved.
//

#import "IdentityChooseViewController.h"
#import "ThirdPartyButton.h"
#import "RegisterController.h"

@interface IdentityChooseViewController ()
@property(assign,nonatomic) NSInteger where;
@property(copy,nonatomic) NSString *openId;
@property(copy,nonatomic) NSString *loginType;
@property(copy,nonatomic) NSString *nickname;
@property(copy,nonatomic) NSString *avatar;
@end

@implementation IdentityChooseViewController

- (instancetype)initWithWhere:(NSInteger)where
{
    if (self = [super init]) {
        self.where = where;
        self.loginType = @"4";
    }
    return self;
}

- (instancetype)initWithWhere:(NSInteger)where WithOpenId:(NSString *)openId WithNickname:(NSString *)nickname WithAvatar:(NSString *)avatar WithLoginType:(NSString *)loginType
{
    if (self = [super init]) {
        self.where = where;
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

- (void)setupNav
{
    
    [self.navigationController.navigationBar setTranslucent:YES];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"backRed" selectedImage:@"backRed" target:self action:@selector(leftBtnDidClick)];
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

- (void)leftBtnDidClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  加载控件
-(void)loadStatusView
{
    UIImageView * imageVeiw = [[UIImageView alloc] initWithFrame:CGRectMake(ZQ_Device_Width/2-100, 80, 200, 27)];
    imageVeiw.image = [UIImage imageNamed:@"identity"];
    [self.view addSubview:imageVeiw];
    
    ThirdPartyButton *bdButton = [[ThirdPartyButton alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width/2 - ZQ_Device_Width/7, CGRectGetMaxY(imageVeiw.frame) + 50, ZQ_Device_Width/7*2, ZQ_Device_Height/7*2)];
    bdButton.iconView.image = [UIImage imageNamed:@"bdButton"];
    bdButton.iconView.frame = ZQ_RECT_CREATE(0, 0, bdButton.width, bdButton.width);
    bdButton.nameLabel.text = @"个人端";
    bdButton.nameLabel.textColor = kUIColorFromRGB(0xf16156);
    bdButton.nameLabel.frame = ZQ_RECT_CREATE(0, CGRectGetMaxY(bdButton.iconView.frame) + 15, bdButton.width, 30);
    [bdButton addTarget:self action:@selector(bdButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bdButton];
    
    ThirdPartyButton *qyButton = [[ThirdPartyButton alloc] initWithFrame:ZQ_RECT_CREATE(ZQ_Device_Width/2 - ZQ_Device_Width/7, CGRectGetMaxY(bdButton.frame), ZQ_Device_Width/7*2, ZQ_Device_Height/7*2)];
    qyButton.iconView.image = [UIImage imageNamed:@"qyButton"];
    qyButton.iconView.frame = ZQ_RECT_CREATE(0, 0, qyButton.width, qyButton.width);
    qyButton.nameLabel.text = @"企业端";
    qyButton.nameLabel.textColor = kUIColorFromRGB(0xf16156);
    qyButton.nameLabel.frame = ZQ_RECT_CREATE(0, CGRectGetMaxY(qyButton.iconView.frame) + 15, qyButton.width, 30);
    [qyButton addTarget:self action:@selector(qyButtonClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:qyButton];
}

- (void)bdButtonClick
{
    if (_where == 1) {
        RegisterController *vc = [[RegisterController alloc] initWithWhere:1 WithIdentity:@"6"];
        vc.isQiyeRegister = NO;
        pushToControllerWithAnimated(vc)
    } else if (_where == 2) {
        RegisterController *vc = [[RegisterController alloc] initWithWhere:2 WithOpenId:_openId WithNickname:_nickname WithAvatar:_avatar WithLoginType:_loginType WithIdentity:@"6"];
        vc.isQiyeRegister = NO;
        pushToControllerWithAnimated(vc)
    }
}

- (void)qyButtonClick
{
    if (_where == 1) {
        RegisterController *vc = [[RegisterController alloc] initWithWhere:1 WithIdentity:@"5"];
        vc.isQiyeRegister = YES;
        pushToControllerWithAnimated(vc)
    } else if (_where == 2) {
        RegisterController *vc = [[RegisterController alloc] initWithWhere:2 WithOpenId:_openId WithNickname:_nickname WithAvatar:_avatar WithLoginType:_loginType WithIdentity:@"5"];
        vc.isQiyeRegister = YES;
        pushToControllerWithAnimated(vc)
    }
}



@end
