//
//  EPopAction.m
//  Easy
//
//  Created by yituiyun on 2017/12/22.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "EPopAction.h"

@interface EPopAction ()
@property (nonatomic, copy, readwrite) NSString *title; ///< 标题
@property (nonatomic, copy, readwrite) void(^handler)(EPopAction *action); ///< 选择回调

@end

@implementation EPopAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(EPopAction *action))handler {
    return [self actionWithImage:nil title:title handler:handler];
}

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(EPopAction *action))handler {
    EPopAction *action = [[self alloc] init];
    action.title = title ? : @"";
    action.handler = handler ? : NULL;
    
    return action;
}

@end
