//
//  NSString+JXExtension.h
//  yituiyun
//
//  Created by 晓梦影 on 2017/8/28.
//  Copyright © 2017年 张强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (JXExtension)

/// 计算文本的大小
+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font andMaxSize:(CGSize)size;

- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size;

@end
