//
//  EHomeViewController.m
//  Easy
//
//  Created by yituiyun on 2017/11/23.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EHomeViewController.h"
#import <JXPageView.h>
#import "EHomeViewController+NotScan.h"
#import "EHomeListViewController.h"
#import "EScanViewController.h"
#import "EHomeViewModel.h"
#import "EPopView.h"
#import "EWebViewController.h"
#import "EUserModel.h"
#import <BAButton/BAButton.h>

#define PageViewTag 111

@interface EHomeViewController ()
@property (nonatomic, strong) EHomeViewModel *viewModel;
@property (nonatomic, strong) UIButton *baRightBtn;
@property (nonatomic, strong) UIButton *baTitleViewBtn;
@property (nonatomic, weak) UIImageView *highLightImageV;

@end

@implementation EHomeViewController
#pragma mark - *** Lazy load
- (UIButton *)baRightBtn{
    if (_baRightBtn == nil) {
        _baRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _baRightBtn.frame = CGRectMake(0, 0, 44, 44);
        _baRightBtn.ba_buttonLayoutType = BAKit_ButtonLayoutTypeCenterImageTop;
        [_baRightBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
        _baRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _baRightBtn.ba_padding = 4;
        [_baRightBtn setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
        [_baRightBtn addTarget:self action:@selector(rightScanAction:) forControlEvents:UIControlEventTouchUpInside];
         [_baRightBtn addTarget:self action:@selector(rightScanChangeHighAction:) forControlEvents:UIControlEventTouchDown];
        [_baRightBtn addTarget:self action:@selector(rightScanDragOutHighAction:) forControlEvents:UIControlEventTouchDragOutside];
        _baRightBtn.adjustsImageWhenHighlighted = NO;
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:_baRightBtn.bounds];
        _highLightImageV = imageV;
        imageV.image = [UIImage imageWithColor:EThemeColor];
        imageV.alpha = .6;
        imageV.hidden = YES;
        [_baRightBtn addSubview:imageV];
    }
    return _baRightBtn;
}
- (UIButton *)baTitleViewBtn{
    if (_baTitleViewBtn == nil) {
        
        _baTitleViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _baTitleViewBtn.frame = CGRectMake(0, 0, 160, 44);
//        NSString *title = @"浙江杰库人力资...";
//        [_baTitleViewBtn setTitle:title forState:UIControlStateNormal];
        _baTitleViewBtn.ba_buttonLayoutType = BAKit_ButtonLayoutTypeCenterImageRight;
        _baTitleViewBtn.ba_padding = 4;
        _baTitleViewBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_baTitleViewBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
        [_baTitleViewBtn addTarget:self action:@selector(baAction:) forControlEvents:UIControlEventTouchUpInside];
//        _baTitleViewBtn.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    }
    return _baTitleViewBtn;
}

- (EHomeViewModel *)viewModel{
    if (_viewModel == nil) {
        
        _viewModel = [[EHomeViewModel alloc]init];
    }
    return _viewModel;
}


#pragma mark - *** Clycle Life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    E_ViewSafeAreInsets(self.view);
    
    /// 检查网络
    [self hasNetwork];
    
    /// 监听网络状态
    [self checkUpNetwork];
    
    /// 监听刷新数据通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hasNetwork) name:ReloadHomeDataAfterScanNotificationName object:nil];
    
    /// 版本更新
    [self checkUpVersion];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ReloadHomeDataAfterScanNotificationName object:nil];
}

#pragma mark - *** Private Method
- (void)hasNetwork{
    JXWeak(self);
    
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    if (kIsNetwork) {
        [self configureAtIndex:0];
        
    }else{
        JXStrong(weakself);
        [self.view jx_showPlaceholderViewWithImageName:@"meiwangluo" desText:@"网络不在状态中" reloadBtnTitle:@"点击加载" reloadBlock:^{
            
            [strongweakself hasNetwork];
        }];
    }
         
     });
}

/// 监听网络状态
- (void)checkUpNetwork{
    JXWeak(self);
    /// 检测网络状态
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType status) {
        if (status == PPNetworkStatusNotReachable || status == PPNetworkStatusUnknown) {
            JXStrong(weakself);
            [self.view jx_showPlaceholderViewWithImageName:@"meiwangluo" desText:@"网络不在状态中" reloadBtnTitle:@"点击加载" reloadBlock:^{
                
                [strongweakself hasNetwork];
            }];
            
        }
    }];
}

/// 版本更新
- (void)checkUpVersion{

    [EHomeViewModel getVersion:^(NSString *iosVersion, NSString *iosUrl, NSString *force) {
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:CheckUpVersion] boolValue] && [[[NSUserDefaults standardUserDefaults]objectForKey:IgnoreCheckUpAppVersion] isEqualToString:iosVersion]) {
            return;
        }
        
        if (![E_APP_VERSION isEqualToString:iosVersion]) {
            
            NSString *appUpdateString = [NSString stringWithFormat:@"检测到最新版本%@,你是否要更新？",iosVersion];
            [self jx_showNewVersionWithDes:appUpdateString isShowNeverUpdate:YES cancelBlock:^(BOOL isNever) {
                JXLog(@"cancel --- %d",isNever);
                /// 是否忽略版本
                [[NSUserDefaults standardUserDefaults]setObject:@(isNever) forKey:CheckUpVersion];
                [[NSUserDefaults standardUserDefaults]synchronize];
                /// 忽略版本号
                [[NSUserDefaults standardUserDefaults]setObject:iosVersion forKey:IgnoreCheckUpAppVersion];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
            } updateBlock:^{
                JXLog(@"updateBlock --- ");
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iosUrl]];
            }];
            
        }
        
    }];
}
/// 根据数据初始化
- (void)configureAtIndex:(NSInteger)idx{
    
    JXWeak(self);
    /// 获取关注的人力公司
    [self.viewModel getMyFollowHr:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakself.viewModel.hrs.count == 0) {
                /// 显示扫码关注人力资源
                [weakself jx_showNotScanView];
                
            }else{
                /// 处理导航条
                if (self.navigationItem.titleView == nil || self.navigationItem.rightBarButtonItem == nil) {
                    [weakself setupNav];
                }
                NSMutableString *title = [NSMutableString stringWithString:weakself.viewModel.hrs[idx].hrName];
                if (title.length > 7) {
                    title = [NSMutableString stringWithString:[title substringToIndex:7]];
                    [title appendString:@"..."];
                }
                weakself.baTitleViewBtn.titleLabel.text = title;
                [weakself.baTitleViewBtn setTitle:title forState:UIControlStateNormal];
                weakself.baTitleViewBtn.ba_buttonLayoutType = BAKit_ButtonLayoutTypeCenterImageRight;
            }
        });
       
        if (weakself.viewModel.hrs.count == 0) {
            return ;
        }
        /// 酒店列表
        [weakself.viewModel getHotelListWithHrId:weakself.viewModel.hrs[idx].hrId completion:^(BOOL hasHotels) {
    
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself setupPageView];
            });
        }];
        
    }];
}


#pragma mark - *** UI
- (void)setupNav{
    
    self.navigationItem.titleView = self.baTitleViewBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.baRightBtn];
}
- (void)setupPageView{
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == PageViewTag) {
            [obj removeFromSuperview];
        }
    }];
    
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *hotelIds = [NSMutableArray array];
    [titles addObject:@"全部"];
    [hotelIds addObject:@"0"];
    [self.viewModel.hotels enumerateObjectsUsingBlock:^(EHomeHotelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:[NSString stringWithFormat:@"%@\n酒店",[obj.name substringToIndex:obj.name.length - 2]]];
        [hotelIds addObject:obj.hotel_id];
    }];
    JXPageStyle *style = [[JXPageStyle alloc]init];
    style.titleFont = [UIFont systemFontOfSize:15];
    style.titleMargin = 40;
    style.isNeedScale = NO;
    style.isScrollEnable = YES;
    style.isShowBottomLine = NO;
    style.multilineEnable = YES;
    style.isShowSeparatorLine = NO;
    style.separatorLineColor = [UIColor colorWithHexString:@"#dddad3"];
    style.titleHeight = 50;
    style.normalColor = [UIColor colorWithHexString:@"#565656"];
    style.selectColor = EThemeColor;
    style.titleGradientEffectEnable = NO;
    
    NSMutableArray *childVcs = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i++){
        EHomeListViewController *vc = [[EHomeListViewController alloc]init];
        vc.hotelId = hotelIds[i];
        [childVcs addObject:vc];
    }
    
    
    CGFloat tarBarHeight = E_TabbarHeight;
    
    if (self.tabBarController.tabBar.hidden) {
        tarBarHeight = 0;
    }
    
    CGRect pageViewFrame = CGRectMake(0, E_StatusBarAndNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - E_StatusBarAndNavigationBarHeight - tarBarHeight);
    
    JXPageView *pageView = [[JXPageView alloc]initWithFrame:pageViewFrame titles:titles style:style childVcs:childVcs parentVc:self];
    pageView.tag = PageViewTag;
    [self.view addSubview:pageView];
    
    
    /// 透明遮盖
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"toumingjuxing"];
    imageView.tag = PageViewTag;
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(E_StatusBarAndNavigationBarHeight);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(60);
    }];
    
}



#pragma mark - *** Actions
- (void)baAction:(UIButton *)button{
    
    JXWeak(self);
    [UIView animateWithDuration:.25 animations:^{
        self.baTitleViewBtn.imageView.transform = CGAffineTransformRotate(self.baTitleViewBtn.imageView.transform, M_PI);
    }];
    
    EPopView *popView = [EPopView popView];
    popView.hideBlock = ^{
        [UIView animateWithDuration:.25 animations:^{
            weakself.baTitleViewBtn.imageView.transform = CGAffineTransformIdentity;
        }];
    };
    __block NSMutableArray *actions = [NSMutableArray array];
    [self.viewModel.hrs enumerateObjectsUsingBlock:^(EHomeHrModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EPopAction *action = [EPopAction actionWithTitle:obj.hrName handler:^(EPopAction *action) {
            [weakself configureAtIndex:idx];
            
        }];
        [actions addObject:action];
    }];
    
    [popView showToPoint:CGPointMake(self.view.centerX, E_StatusBarAndNavigationBarHeight) withActions:actions];
    
}

- (void)rightScanAction:(UIButton *)button{
    _highLightImageV.hidden = YES;
    EScanViewController *vc = [[EScanViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)rightScanDragOutHighAction:(UIButton *)button{
     _highLightImageV.hidden = YES;
}

- (void)rightScanChangeHighAction:(UIButton *)button{
    if (button.isHighlighted) {
        _highLightImageV.hidden = NO;
    }else{
        
        _highLightImageV.hidden = YES;
    }
}

#pragma mark - *** JXQRScanViewControllerDelegate
- (void)QRScanViewController:(JXQRScanViewController *)vc results:(NSArray<NSString *> *)results{
    
    NSString *urlString = nil;
    NSString *content = results.firstObject;
    BOOL isShowURLWhenFail = NO;
    if ([content hasPrefix:@"http"]) {
        /// 1.h5
        urlString = content;
        isShowURLWhenFail = YES;
    }
    else{
        
        urlString = [NSString stringWithFormat:@"%@%@/%@",kQRCodeApi,content,[EUserInfoManager getUserInfo].userId];
    }
    
    EWebViewController *webVc = [[EWebViewController alloc]init];
//    webVc.urlString = [NSString stringWithFormat:@"%@%@/%@",kWebViewApiPrefix,results.firstObject,[EUserInfoManager getUserInfo].userId];
    webVc.isShowURLWhenFail = isShowURLWhenFail;
    webVc.urlString = urlString;
    [self.navigationController pushViewController:webVc animated:YES];
    
    JXLog(@"results == %@",results);
    JXLog(@"urlString == %@",urlString);

}


@end
