//
//  ZQ_ViewController.h
//  朝阳项目
//
//  Created by NIT on 15/5/4.
//  Copyright (c) 2015年 ZQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+HUD.h"

@interface ZQ_ViewController : UIViewController

/** 用于无UINavigationController作为容器的viewController中 */
@property (nonatomic, strong) UIView *contentView;

@end
