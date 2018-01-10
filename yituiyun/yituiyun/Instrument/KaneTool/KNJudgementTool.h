//
//  KNJudgementTool.h
//  
//
//  Created by LUKHA_Lu on 15/7/16.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KNJudgementTool : NSObject


/**
 *  判断该字符串是否为空
 *
 *  @param string 当前
 *
 *  @return bool类型,YES:为空  NO:不为空
 */
+ (BOOL)isEmptyString:(NSString *)string;


/**
 *  判断该数组是否为空
 *
 *  @param array 当前array
 *
 *  @return bool类型,YES:为空  NO:不为空
 */
+ (BOOL)isEmptyArray:(NSArray *)array;

/**
 *  自动生成一个普通label
 *
 *  @param font   字体
 *  @param string 普通文字
 *  @param color  颜色
 *
 *  @return 返回一个label
 */
+ (UILabel *)formatLabelWithFont:(UIFont *)font string:(NSString *)string textColor:(UIColor *)color;

/**
 *  自动生成 带行间距的label,但必须主动设置size, 而当前label 实现: CGSize labelSize = [label sizeThatFits:size];再设置frame
 *
 *  @param font       字体
 *  @param attrString 普通文字
 *  @param lineSpace  行间距
 *  @param color      颜色
 *
 *  @return 返回一个label
 */
+ (UILabel *)formatLabelWithFont:(UIFont *)font attriString:(NSString *)attrString lineSpace:(CGFloat)lineSpace textColor:(UIColor *)color;

@end
