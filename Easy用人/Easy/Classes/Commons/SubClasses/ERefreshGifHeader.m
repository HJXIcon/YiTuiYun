//
//  ERefreshGifHeader.m
//  Easy
//
//  Created by yituiyun on 2017/11/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ERefreshGifHeader.h"

@implementation ERefreshGifHeader
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading (%ld)_32x32_", i]];
        [idleImages addObject:image];
    }
    
    
    [self setImages:idleImages duration:1.0 forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading (%ld)_32x32_", i]];
        [refreshingImages addObject:image];
    }
    
    [self setImages:idleImages duration:1.0 forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:idleImages duration:1.0 forState:MJRefreshStateRefreshing];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
}

@end
