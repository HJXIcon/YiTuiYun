//
//  EPopView.h
//  Easy
//
//  Created by yituiyun on 2017/12/22.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPopAction.h"

UIKIT_EXTERN float const kPopViewCellHeight;

@interface EPopView : UIView
@property (nonatomic, copy) void(^hideBlock)(void);
+ (instancetype)popView;

- (void)showToPoint:(CGPoint)toPoint withActions:(NSArray<EPopAction *> *)actions;

@end
