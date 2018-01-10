//
//  UIView+XSmartExtension.m
//  XSmart
//
//  Created by 孙浩天 on 16/3/3.
//  Copyright © 2016年 孙浩天. All rights reserved.
//

#import "UIView+XSmartExtension.h"

@implementation UIView(XSmartExtension)

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

/**
 * @获取UIView宽度
 *
 */
-(CGFloat)width{
    return self.frame.size.width;
}

/**
 * @修改UIView宽度
 *
 */
-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    return;
}

/**
 * @获取UIView宽度
 *
 */
-(CGFloat)height{
    return self.frame.size.height;
}

/**
 * @修改UIView宽度
 *
 */
-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    return;
}

/**
 * @获取UIView 最小X轴
 *
 */
-(CGFloat)MinX{
    return self.frame.origin.x;
}

/**
 * @修改UIView 最小X轴
 *
 */
-(void)setMinX:(CGFloat)MinX{
    CGRect frame = self.frame;
    frame.origin.x = MinX;
    self.frame = frame;
    return;
}

/**
 * @获取UIView 最小Y轴
 *
 */
-(CGFloat)MinY{
    return self.frame.origin.y;
}

/**
 * @修改UIView 最小Y轴
 *
 */
-(void)setMinY:(CGFloat)MinY{
    CGRect frame = self.frame;
    frame.origin.y = MinY;
    self.frame = frame;
    return;
}

/**
 * @获取UIView 最大X轴
 *
 */
-(CGFloat)MaxX{
    return [self MinX]+[self width];
}

/**
 * @修改UIView 最大X轴
 *
 */
-(void)setMaxX:(CGFloat)MaxX{
    CGRect frame = self.frame;
    frame.origin.y = MaxX;
    self.frame = frame;
    return;
}

/**
 * @获取UIView 最大Y轴
 *
 */
-(CGFloat)MaxY{
    return [self MinY] + [self height];
}

/**
 * @修改UIView 最大Y轴
 *
 */
-(void)setMaxY:(CGFloat)MaxY{
    CGRect frame = self.frame;
    frame.origin.y = MaxY - [self height];
    self.frame = frame;
    return;
}

/**
 * @获取UIView 中间X轴
 *
 */
-(CGFloat)centerX{
    return self.center.x;
}

/**
 * @修改UIView 中间X轴
 *
 */
-(void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}

/**
 * @获取UIView 中间Y轴
 *
 */
-(CGFloat)centerY{
    return self.center.y;
}

/**
 * @修改UIView 中间Y轴
 *
 */
-(void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
    return;
}

/**
 * @移除此view上的所有子视图
 *
 */
-(void)removeAllSubviews{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    return;
}

@end
