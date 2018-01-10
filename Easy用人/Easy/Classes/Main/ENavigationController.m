//
//  ENavigationController.m
//  Easy
//
//  Created by yituiyun on 2017/11/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ENavigationController.h"
#import "EWebViewController.h"

@interface ENavigationController ()
/** 全局返回按钮 */
@property (strong, nonatomic) UIButton *backBtn;
@end

@implementation ENavigationController

#pragma mark - lazy loading
- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [_backBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateHighlighted
         ];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        CGFloat btnW =  54;
        _backBtn.frame = CGRectMake(0, 0, btnW, 30);
        
    }
    return _backBtn;
}


+ (void)initialize{
    // 设置全局BarButtonItem
    //    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil ];

    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18.0];
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    
     UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    
    //设置一张空的图片
    [bar setShadowImage:[[UIImage alloc]init]];
    NSMutableDictionary *dicBar = [NSMutableDictionary dictionary];
    dicBar[NSFontAttributeName] = [UIFont systemFontOfSize:E_FontRadio(18)];
    dicBar[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [bar setTitleTextAttributes:dicBar];
   
    
    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, E_StatusBarAndNavigationBarHeight)];
//    imageView.image = [UIImage imageNamed:@"dingdaohang"];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;

//     全局navigationBar
//     真机上显示的却向下移动了64 bug  -->> 解决设置图片透明度小于1
//    [bar setBackgroundImage:[UIImage createImageFromView:imageView] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *image = [self getGradientWithFrame:CGRectMake(0, 0, kScreenW, E_StatusBarAndNavigationBarHeight)];
    image = [UIImage imageByApplyingAlpha:0.99 image:image];
    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 取消代理
    self.interactivePopGestureRecognizer.delegate = nil;
    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];

    if (self.viewControllers.count > 0) {

        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
        viewController.hidesBottomBarWhenPushed = YES;

    }
    return [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    for (UIViewController *controller in self.viewControllers) {
        if ([controller isKindOfClass:[EWebViewController class]]) {
            [self popToRootViewControllerAnimated:animated];
        }
    }
    
    return [super popViewControllerAnimated:animated];
}

/**
 * 返回按钮点击
 */

- (void)backBtnClick {
    [self popViewControllerAnimated:YES];

}


/**
 获取颜色梯度图片
 */
+ (UIImage *)getGradientWithFrame:(CGRect)frame{
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    [gradient setColors:[NSArray arrayWithObjects:
                         (id)[[UIColor colorWithHexString:@"#ffce3d"] CGColor],
                         (id)[[UIColor colorWithHexString:@"#ffbf00"] CGColor], nil]];
    
    // 一个可选的NSNumber数组，决定每个渐变颜色的终止位置，这些值必须是递增的，数组的长度和colors的长度最好一致，在如上的例子中如果修改如下代码；
    [gradient setLocations:@[@0.0,@1.0]];
    // 分别表示渐变层的起始位置和终止位置，这两个点被定义在一个单元坐标空间，[0,0]表示左上角位置，[1,1]表示右下角位置，默认值分别是[.5,0] and [.5,1]；
    [gradient setStartPoint:CGPointMake(0.0, 0.5)];
    [gradient setEndPoint:CGPointMake(1.0, 0.5)];
    
    UIGraphicsBeginImageContextWithOptions(gradient.frame.size, NO, [UIScreen mainScreen].scale);
    [gradient renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}



@end
