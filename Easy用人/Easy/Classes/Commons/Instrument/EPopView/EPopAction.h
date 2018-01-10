//
//  EPopAction.h
//  Easy
//
//  Created by yituiyun on 2017/12/22.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPopAction : NSObject
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) void(^handler)(EPopAction *action);

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(EPopAction *action))handler;

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(EPopAction *action))handler;

@end
