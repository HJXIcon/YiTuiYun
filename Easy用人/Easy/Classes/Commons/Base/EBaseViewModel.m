//
//  EBaseViewModel.m
//  Easy
//
//  Created by yituiyun on 2017/12/22.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EBaseViewModel.h"
#import <MBProgressHUD.h>
MBProgressHUD *HUD;

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation EBaseViewModel

+ (void)showHint:(NSString *)hint{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    [hud setY:  IS_IPHONE_5?200.f:150.f];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint
{
    [[self class] showHint:hint];
}

+ (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    hud.y = IS_IPHONE_5?200.f:150.f;
    hud.y += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}


- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    [[self class] showHint:hint yOffset:yOffset];
}

/// >>>> 加载中...
+ (void)jx_showLoadingAnimation{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MBProgressHUD class]]) {
            [self hideHud];
        }
    }];
    [self showAnimatedHint:@"加载中..."];
}
- (void)jx_showLoadingAnimation{
    [[self class] jx_showLoadingAnimation];
}

+ (void)jx_dimissLoadingAnimation{
    [self hideHud];
}
- (void)jx_dimissLoadingAnimation{
    [[self class] jx_dimissLoadingAnimation];
}

/// >>> 服务器异常
+ (void)showFailureMsg{
    [self showHint:@"服务器异常"];
}
- (void)showFailureMsg{
    [[self class] showFailureMsg];
}

/// >>>> 菊花动画
+ (void)showAnimatedHint:(NSString *)hint{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.label.text = hint;
    [HUD showAnimated:YES];
}
- (void)showAnimatedHint:(NSString *)hint{
    [[self class] showAnimatedHint:hint];
}

+ (void)hideHud{
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hideAnimated:YES];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    HUD = nil;
}

- (void)hideHud{
    [[self class] hideHud];
}
@end
