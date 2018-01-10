//
//  ThirdPartyChooseController.m
//  荣坤
//
//  Created by NIT on 15-3-11.
//  Copyright (c) 2015年 NIT. All rights reserved.
//

#import "ThirdPartyChooseController.h"
#import "IdentityChooseViewController.h"
#import "AssociateViewController.h"

@interface ThirdPartyChooseController ()<UITextFieldDelegate>

@property(copy,nonatomic) NSString *openId;
@property(copy,nonatomic) NSString *loginType;
@property(copy,nonatomic) NSString *nickname;
@property(copy,nonatomic) NSString *avatar;
@end

@implementation ThirdPartyChooseController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    self.view.backgroundColor = kUIColorFromRGB(0xffffff);
    
    UIImageView *imageV1 = [[UIImageView alloc] init];
    [imageV1 sd_setImageWithURL:[NSURL URLWithString:_avatar] placeholderImage:[UIImage imageNamed:@"defaulticon.png"]];
    imageV1.frame = ZQ_RECT_CREATE(ZQ_Device_Width/2-ZQ_Device_Width/10, 104, ZQ_Device_Width/5, ZQ_Device_Width/5);
    imageV1.clipsToBounds = true;
    imageV1.layer.cornerRadius = imageV1.height / 2;
    [self.view addSubview:imageV1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(30, CGRectGetMaxY(imageV1.frame) + 20, 120, 40)];
    label.text = @"亲爱的微信会员：";
    CGSize labeleSize = [label.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, 40)];
    label.frame = ZQ_RECT_CREATE(30, CGRectGetMaxY(imageV1.frame) + 20, labeleSize.width + 10, 40);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = kUIColorFromRGB(0x888888);
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(label.frame), CGRectGetMaxY(imageV1.frame) + 20, ZQ_Device_Width - CGRectGetMaxX(label.frame) - 12, 40)];
    label1.text = _nickname;
    label1.textAlignment = NSTextAlignmentLeft;
    label1.textColor = kUIColorFromRGB(0x404040);
    label1.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(30, CGRectGetMaxY(label1.frame), ZQ_Device_Width - 60, 50)];
    label2.text = @"为了给您更好的服务，请关联一个易推云账号";
    label2.numberOfLines = 2;
    label2.textColor = kUIColorFromRGB(0x888888);
    label2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(30, CGRectGetMaxY(label2.frame)+5, ZQ_Device_Width - 60, 40)];
    label3.text = @"还没有易推云账号？";
    label3.textAlignment = NSTextAlignmentLeft;
    label3.textColor = kUIColorFromRGB(0x888888);
    label3.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label3];
    
    //快速注册button
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    registerButton.frame = CGRectMake(40, CGRectGetMaxY(label3.frame), ZQ_Device_Width - 80, 50);
    [registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [registerButton setTintColor:[UIColor whiteColor]];
    registerButton.backgroundColor = kUIColorFromRGB(0xf16156);
    registerButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [[registerButton layer] setCornerRadius:5];
    [[registerButton layer] setMasksToBounds:YES];
    [registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(30, CGRectGetMaxY(registerButton.frame) + 20, ZQ_Device_Width - 60, 40)];
    label4.text = @"已有易推云账号？";
    label4.textAlignment = NSTextAlignmentLeft;
    label4.textColor = kUIColorFromRGB(0x888888);
    label4.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label4];
    
    //立即关联Button
    UIButton *associatedButton = [UIButton buttonWithType:UIButtonTypeSystem];
    associatedButton.frame = CGRectMake(40, CGRectGetMaxY(label4.frame), ZQ_Device_Width - 80, 50);
    [[associatedButton layer] setCornerRadius:5];
    [[associatedButton layer] setMasksToBounds:YES];
    [associatedButton setTitle:@"立即关联" forState:UIControlStateNormal];
    associatedButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [associatedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    associatedButton.backgroundColor = kUIColorFromRGB(0xf16156);
    [associatedButton addTarget:self action:@selector(associatedButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:associatedButton];
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
    label.text = @"联合登录";
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


- (void)registerButtonClick
{
    IdentityChooseViewController *vc = [[IdentityChooseViewController alloc] initWithWhere:2 WithOpenId:_openId WithNickname:_nickname WithAvatar:_avatar WithLoginType:_loginType];
    pushToControllerWithAnimated(vc)
}

- (void)associatedButtonClick
{
    AssociateViewController *vc = [[AssociateViewController alloc] initWithWithOpenId:_openId WithNickname:_nickname WithAvatar:_avatar WithLoginType:_loginType];
    pushToControllerWithAnimated(vc)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
