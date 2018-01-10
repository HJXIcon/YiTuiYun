//
//  MBProgressHUD+KN.m
//  妈咪宝贝
//
//  Created by LUKHA_Lu on 15/6/6.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import "MBProgressHUD+KN.h"

@implementation MBProgressHUD (KN)

+ (void)showOnlyTextOneView:(UIView *)view message:(NSString *)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

//+ (void)showWithOutBackGroundWithDetailsLabel:(UIView *)view message:(NSString *)message withController:(UIViewController *)viewController{
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
//        [view addSubview:HUD];
//        HUD.delegate = viewController;
//        HUD.labelText = message;
//    
//        [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
//}

//+ (void)showWithOutBackGroundWithDetailsLabel:(UIView *)view message:(NSString *)message{
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
//    [view addSubview:HUD];
//    
//    HUD.delegate = self;
//    HUD.labelText = @"Loading";
//    
//    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
//}

@end
