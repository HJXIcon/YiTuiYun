//
//  ERefreshAutoGifFooter.m
//  Easy
//
//  Created by yituiyun on 2017/11/13.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ERefreshAutoGifFooter.h"

@implementation ERefreshAutoGifFooter
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=50; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading (%ld)_32x32_", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages duration:1.0 forState:MJRefreshStateRefreshing];
}


@end
