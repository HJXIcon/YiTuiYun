//
//  KNNavigationController.m
//  NavTest
//
//  Created by LUKHA_Lu on 15/10/9.
//  Copyright (c) 2015年 KNKane. All rights reserved.
//

#import "KNNavigationController.h"

@interface KNNavigationController ()

@end

@implementation KNNavigationController


+ (void)initialize{
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[KNNavigationController class], nil];
    
    [bar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    [bar setTintColor:[UIColor blackColor]];
    
    // 设置导航条的标题颜色
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSForegroundColorAttributeName] = [UIColor blackColor];
    dictM[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
    [bar setTitleTextAttributes:dictM];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:0 target:self action:@selector(leftBtnWillPopback)];
}

#pragma mark - 正常情况下的返回按钮
- (void)leftBtnWillPopback{

    [self popViewControllerAnimated:YES];
}

@end
