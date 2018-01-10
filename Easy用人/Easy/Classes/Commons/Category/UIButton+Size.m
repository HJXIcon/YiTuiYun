//
//  UIButton+Size.m
//  Easy
//
//  Created by yituiyun on 2017/11/16.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "UIButton+Size.h"

@implementation UIButton (Size)

- (CGSize)jx_sizeToFitWithHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical{
    
    CGFloat Width = ceilf([self.titleLabel.text sizeWithFont:self.titleLabel.font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width);
    CGFloat Height = ceilf([self.titleLabel.text sizeWithFont:self.titleLabel.font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height);
    Width += horizontal;
    Height += vertical;
    
    
    return  CGSizeMake(Width, Height);
}
@end

@implementation UILabel (Size)

- (CGSize)jx_sizeToFitWithHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical{
    
    CGFloat Width = ceilf([self.text sizeWithFont:self.font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width);
    CGFloat Height = ceilf([self.text sizeWithFont:self.font andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height);
    Width += horizontal;
    Height += vertical;
    
    
    return  CGSizeMake(Width, Height);
}
@end

