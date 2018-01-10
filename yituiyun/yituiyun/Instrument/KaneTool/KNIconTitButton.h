//
//  KNIconTitButton.h
//  社区快线
//
//  Created by LUKHA_Lu on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//  生成一个 按钮 待着 位子, 图片 已经图片上 有小红点(显示多少个)

#import <UIKit/UIKit.h>

@interface KNIconTitButton : UIButton

/* 图片的名字 描述的文字 */
@property (nonatomic,copy) NSString *iconString;
@property (nonatomic,copy) NSString *describString;

/* 数字的颜色 描述的颜色 */
@property (nonatomic, strong) UIColor *describColor;

/* 文字的字体 */
@property (nonatomic, strong) UIFont *stringFont;

@property (nonatomic,assign) NSInteger number;

@end
