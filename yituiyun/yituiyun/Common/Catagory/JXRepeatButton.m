//
//  MyButton.m
//  test
//
//  Created by 晓梦影 on 2017/8/28.
//  Copyright © 2017年 黄金星. All rights reserved.
//

#import "JXRepeatButton.h"
// 默认的按钮点击时间
static const NSTimeInterval defaultDuration = 2.0f;
// 记录是否忽略按钮点击事件，默认第一次执行事件
static BOOL _isIgnoreEvent = NO;

// 设置执行按钮事件状态
static void resetState() {
    _isIgnoreEvent = NO;
}


@implementation JXRepeatButton



- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
     //1. 按钮点击间隔事件
     _time = _time == 0 ? defaultDuration : _time;
    
    //2. 是否忽略按钮点击事件
    
    if (_isIgnoreEvent) {
        //2.1 忽略按钮事件
        // 直接拦截掉super函数进行发送消息
        return;
        
    }else if (_time > 0){
        
         //2.2 不忽略按钮事件
        // 后续在间隔时间内直接忽略按钮事件
         _isIgnoreEvent = YES;
        
        // 间隔事件后，执行按钮事件
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            resetState();
        });
    }
    
    // 发送按钮点击消息
    [super sendAction:action to:target forEvent:event];
    
}

@end
