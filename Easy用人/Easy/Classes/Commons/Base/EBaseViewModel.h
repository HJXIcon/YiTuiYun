//
//  EBaseViewModel.h
//  Easy
//
//  Created by yituiyun on 2017/12/22.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBaseViewModel : NSObject
- (void)showHint:(NSString *)hint;
+ (void)showHint:(NSString *)hint;
// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;
+ (void)showHint:(NSString *)hint yOffset:(float)yOffset;

/// >>>> 加载中...
- (void)jx_showLoadingAnimation;
+ (void)jx_showLoadingAnimation;
- (void)jx_dimissLoadingAnimation;
+ (void)jx_dimissLoadingAnimation;

/// >>> 服务器异常
+ (void)showFailureMsg;
- (void)showFailureMsg;

/// >>>> 菊花动画
+ (void)showAnimatedHint:(NSString *)hint;
- (void)showAnimatedHint:(NSString *)hint;
+ (void)hideHud;
- (void)hideHud;


@end
