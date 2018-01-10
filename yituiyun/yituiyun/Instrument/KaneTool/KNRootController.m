//
//  KNRootController.m
//  NavTest
//
//  Created by LUKHA_Lu on 15/10/9.
//  Copyright (c) 2015年 KNKane. All rights reserved.
//

#import "KNRootController.h"

@interface KNRootController ()

@end

@implementation KNRootController

- (instancetype)init{
    if(self = [super init]){
        self.hidesBottomBarWhenPushed  = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
