//
//  NSArray+Safe.m
//  yituiyun
//
//  Created by yituiyun on 2017/5/17.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (Safe)

@end



#import "NSArray+Safe.h"
#import <objc/runtime.h>
@implementation NSArray (Safe)
//这个方法无论如何都会执行
+ (void)load {
    // 选择器
    SEL safeSel = @selector(safeObjectAtIndex:);
    SEL unsafeSel = @selector(objectAtIndex:);
    
    Class class = NSClassFromString(@"__NSArrayI");
    // 方法
    Method safeMethod = class_getInstanceMethod(class, safeSel);
    Method unsafeMethod = class_getInstanceMethod(class, unsafeSel);
    
    // 交换方法
    method_exchangeImplementations(unsafeMethod, safeMethod);
}


- (id)safeObjectAtIndex:(NSUInteger)index {
    // 数组越界也不会崩，但是开发的时候并不知道数组越界
    if (index > (self.count - 1) || self== nil) { // 数组越界
        [SVProgressHUD showErrorWithStatus:@"数组越界"]; // 只有开发的时候才会造成程序崩了
        return nil;
    }else { // 没有越界
        
//        NSLog(@"-------%ld---",self.count);
        return [self safeObjectAtIndex:index];
    }
}
@end
