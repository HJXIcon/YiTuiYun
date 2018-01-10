//
//  UIView+XSmartExtension.h
//  XSmart
//
//  Created by 孙浩天 on 16/3/3.
//  Copyright © 2016年 孙浩天. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(XSmartExtension)

/**
 * @获取或修改UIView宽度
 *
 */
@property (nonatomic) CGFloat width;

/**
 * @获取或修改UIView高度
 *
 */
@property (nonatomic) CGFloat height;

/**
 * @获取或修改UIView 最小X轴
 *
 */
@property (nonatomic) CGFloat MinX;

/**
 * @获取或修改UIView 最小Y轴
 *
 */
@property (nonatomic) CGFloat MinY;

/**
 * @获取或修改UIView 最大X轴
 *
 */
@property (nonatomic) CGFloat MaxX;

/**
 * @获取或修改UIView 最大Y轴
 *
 */
@property (nonatomic) CGFloat MaxY;

/**
 * @获取或修改UIView 中间X轴
 *
 */
@property (nonatomic) CGFloat centerX;

/**
 * @获取或修改UIView 中间Y轴
 *
 */
@property (nonatomic) CGFloat centerY;

//方法开始

/**
 * @移除此view上的所有子视图
 *
 */
-(void)removeAllSubviews;

@end
