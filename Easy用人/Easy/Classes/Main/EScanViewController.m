//
//  EScanViewController.m
//  Easy
//
//  Created by yituiyun on 2017/11/15.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EScanViewController.h"

@interface EScanViewController ()
@property (nonatomic, assign) BOOL isOpenFlash;
/**
 @brief  扫码区域下方提示文字
 */
@property (nonatomic, strong) UILabel *bottomTitleLabel;

//底部显示的功能项
@property (nonatomic, strong) UIView *bottomView;
/// 相册
@property (nonatomic, strong) UIButton *btnPhoto;
/// 相册文字
@property (nonatomic, strong) UILabel *photoLabel;

/// 闪光灯
@property (nonatomic, strong) UIButton *btnFlash;
/// 闪光灯文字
@property (nonatomic, strong) UILabel *flashLabel;
@end

@implementation EScanViewController

#pragma mark - *** lazy load
- (UILabel *)photoLabel{
    if (_photoLabel == nil) {
        _photoLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(16)] textColor:[UIColor whiteColor] text:@"相册" textAlignment:NSTextAlignmentCenter];
        _photoLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPhoto)];
        [_photoLabel addGestureRecognizer:tap];
    }
    return _photoLabel;
}
- (UIButton *)btnPhoto{
    if (_btnPhoto == nil) {
        _btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPhoto setBackgroundImage:[UIImage imageNamed:@"xiangce"] forState:UIControlStateNormal];
        [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPhoto;
}
- (UIView *)bottomView{
    if (_bottomView == nil) {
        
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
    }
    return _bottomView;
}

- (UILabel *)flashLabel{
    if (_flashLabel == nil) {
        _flashLabel = [JXFactoryTool creatLabel:CGRectZero font:[UIFont systemFontOfSize:E_FontRadio(14)] textColor:[UIColor whiteColor] text:@"轻点照亮" textAlignment:NSTextAlignmentCenter];
        _flashLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openOrCloseFlash)];
        [_flashLabel addGestureRecognizer:tap];
    }
    return _flashLabel;
}
- (UILabel *)bottomTitleLabel{
    if (_bottomTitleLabel == nil) {
        _bottomTitleLabel = [[UILabel alloc]init];
        _bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
        _bottomTitleLabel.text = @"将二维码放入框内，即可扫描";
        _bottomTitleLabel.textColor = [UIColor whiteColor];
        _bottomTitleLabel.font = [UIFont systemFontOfSize:E_FontRadio(16)];
    }
    return _bottomTitleLabel;
}

- (UIButton *)btnFlash{
    if (_btnFlash == nil) {
        _btnFlash = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFlash setBackgroundImage:[UIImage imageNamed:@"shoudian"] forState:UIControlStateNormal];
        [_btnFlash setBackgroundImage:[UIImage imageNamed:@"shoudian-kai"] forState:UIControlStateSelected];
        [_btnFlash addTarget:self action:@selector(openOrCloseFlash:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnFlash;
}

#pragma mark - *** cycle Life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫描二维码";
    JXQRScanStyle *style = [[JXQRScanStyle alloc]init];
    style.colorAngle = [UIColor colorWithHexString:@"#ffbf00"];
    style.retanglePadding = (kScreenW - E_RealWidth(190))* 0.5;
    style.isNeedShowRetangle = NO;
    style.isDrawQRCodeRect = NO;
    style.colorNotRecoginitonArea = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    style.anmiationStyle = JXQRScanAnimationStyleLine;
    style.animationImage = [UIImage imageNamed:@"saomiao"];
    style.centerUpOffset = E_RealHeight(64);
    self.style = style;

    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self setupUI];
   
}


//绘制扫描区域
- (void)setupUI{
    
    CGFloat Y = self.navigationController.navigationBar.hidden == YES ? E_RealHeight(320) : E_StatusBarAndNavigationBarHeight + E_RealHeight(320);
    [self.view addSubview:self.bottomTitleLabel];
    [self.view bringSubviewToFront:self.bottomTitleLabel];
    [self.bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(Y);
    }];
    
    [self.view addSubview:self.btnFlash];
    [self.view bringSubviewToFront:self.btnFlash];
    [self.btnFlash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.bottomTitleLabel.mas_bottom).offset(E_RealHeight(62));
    }];
    
    [self.view addSubview:self.flashLabel];
    [self.view bringSubviewToFront:self.flashLabel];
    [self.flashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.btnFlash.mas_bottom).offset(E_RealHeight(7));
    }];
    
    
    ///
    [self.view addSubview:self.bottomView];
    [self.view bringSubviewToFront:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.height.mas_equalTo(E_RealHeight(65));
    }];
    
    [self.bottomView addSubview:self.btnPhoto];
    [self.btnPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bottomView);
        make.top.mas_equalTo(self.bottomView).offset(E_RealHeight(9));
    }];
    
    [self.bottomView addSubview:self.photoLabel];
    [self.photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bottomView);
        make.top.mas_equalTo(self.btnPhoto.mas_bottom).offset(E_RealHeight(6));
    }];
    
}






#pragma mark - *** Actions
//打开相册
- (void)openPhoto{
    [self openPhotoAndScanImage:NO];
}

//开关闪光灯
- (void)openOrCloseFlash:(UIButton *)button
{
    self.isOpenFlash = !self.isOpenFlash;
    self.btnFlash.selected = self.isOpenFlash;
    [super openOrCloseFlash];
    
}

- (void)openOrCloseFlash{
    self.isOpenFlash = !self.isOpenFlash;
    self.btnFlash.selected = self.isOpenFlash;
    [super openOrCloseFlash];
}



@end
