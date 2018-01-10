//
//  ELaunchViewController.m
//  Easy
//
//  Created by yituiyun on 2017/12/19.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ELaunchViewController.h"
#import "ELaunchAdView.h"

@interface ELaunchViewController ()

@end

@implementation ELaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ELaunchAdView *ad = [[ELaunchAdView alloc]initWithFrame:self.view.bounds];
    
    ad.launchEndBlock = ^{
       [UIApplication sharedApplication].keyWindow.rootViewController = [EControllerManger chooseRootController];
    };
    [self.view addSubview:ad];
}

@end
