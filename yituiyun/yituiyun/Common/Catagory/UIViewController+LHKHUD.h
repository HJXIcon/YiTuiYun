//
//  UIViewController+LHKHUD.h
//  yituiyun
//
//  Created by yituiyun on 2017/5/11.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MainViewController.h"

@interface UIViewController (LHKHUD)
- (void)_showHudInView:(UIView *)view hint:(NSString *)hint;
- (void)_showHudInView1:(UIView *)view hint:(NSString *)hint;

- (void)_hideHud;

- (void)_showHint:(NSString *)hint;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)_showHint:(NSString *)hint yOffset:(float)yOffset;

-(void)setupForDismissKeyboard;
-(UINavigationController *)getTabBarVcChilrdVC:(NSInteger)index;

@end
