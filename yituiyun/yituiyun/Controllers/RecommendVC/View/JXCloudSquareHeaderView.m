//
//  JXCloudSquareHeaderView.m
//  yituiyun
//
//  Created by 晓梦影 on 2017/10/9.
//  Copyright © 2017年 张强. All rights reserved.
//

#import "JXCloudSquareHeaderView.h"
#import "LoginViewController.h"
#import "LHKNavController.h"

@interface JXCloudSquareHeaderView ()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *leftBottomLine;
@property (nonatomic, strong) UIView *rightBottomLine;
@end
@implementation JXCloudSquareHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    
    self.leftBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:17] normalColor:UIColorFromRGBString(@"0x4a4a4a") selectColor:UIColorFromRGBString(@"0xf16156") title:@"商家信息" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(leftAction:)];
    [self addSubview:self.leftBtn];
    self.leftBtn.selected = YES;
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake((ScreenWidth - 1) * 0.5, 44));
    }];
    
    self.rightBtn = [JXFactoryTool creatButton:CGRectZero font:[UIFont systemFontOfSize:17] normalColor:UIColorFromRGBString(@"0x4a4a4a") selectColor:UIColorFromRGBString(@"0xf16156") title:@"通知中心" nornamlImageName:nil selectImageName:nil textAlignment:NSTextAlignmentCenter target:self action:@selector(rightAction:)];
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake((ScreenWidth - 1) * 0.5, 44));
    }];
    
    [self masonry_distributeSpacingHorizontallyWith:@[self.leftBtn,self.rightBtn]];
    
    UIView *midLine = [[UIView alloc]init];
    midLine.backgroundColor = UIColorFromRGBString(@"0xf6f6f6");
    [self addSubview:midLine];
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftBtn.mas_right);
        make.width.mas_equalTo(1);
        make.top.bottom.mas_equalTo(self);
    }];
    
    
    
    self.leftBottomLine = [[UIView alloc]init];
    self.leftBottomLine.backgroundColor = UIColorFromRGBString(@"0xf16156");
    [self addSubview:self.leftBottomLine];
    [self.leftBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo((ScreenWidth - 1) * 0.5);
        make.right.mas_equalTo(self.leftBtn);
    }];
    
    
    self.rightBottomLine = [[UIView alloc]init];
    self.rightBottomLine.backgroundColor = UIColorFromRGBString(@"0xf16156");
    [self addSubview:self.rightBottomLine];
    [self.rightBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo((ScreenWidth - 1) * 0.5);
        make.right.mas_equalTo(self.rightBtn);
    }];
    self.rightBottomLine.hidden = YES;
}

#pragma mark - Public Method
- (void)leftAction{
    [self leftAction:self.leftBtn];
}

#pragma mark - Actions
- (void)rightAction:(UIButton *)button{
    
    self.leftBtn.selected = NO;
    self.rightBtn.selected = YES;
    self.rightBottomLine.hidden = NO;
    self.leftBottomLine.hidden = YES;
   
    /// 判断是否登录
    if ([self isLogin]) {
        if (self.selectBlock) {
            self.selectBlock(1);
        }
        
    }else{
        [self leftAction:self.rightBtn];
    }
    
}

- (void)leftAction:(UIButton *)button{
    
    self.leftBtn.selected = YES;
    self.rightBtn.selected = NO;
    self.leftBottomLine.hidden = NO;
    self.rightBottomLine.hidden = YES;
   
    if (self.selectBlock) {
        self.selectBlock(0);
    }
}

- (BOOL)isLogin{
    UserInfoModel *model = [ZQ_AppCache userInfoVo];
    if ([model.userID isEqualToString:@"0"]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init:2];
        LHKNavController *nav = [self addNavigationController:loginVC];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

- (LHKNavController *)addNavigationController:(UIViewController *)viewController
{
    LHKNavController *nav = [[LHKNavController alloc] initWithRootViewController:viewController];
    //修改所有导航栏控制器的title属性
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    //修改所有导航栏的背景图片
    
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:kUIColorFromRGB(0xf16156)] forBarMetrics:UIBarMetricsDefault];
    
    return nav;
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


@end
