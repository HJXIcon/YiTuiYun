//
//  KNSubViewsBtn.h
//  社区快线
//
//  Created by LUKHA_Lu on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//  一个按钮上面有 两个 label, 上下各一个

#import <UIKit/UIKit.h>

@interface KNSubViewsBtn : UIButton

/* 数字的文字 描述的文字 */

@property (nonatomic,copy) NSString *numberString;
@property (nonatomic,copy) NSString *describString;

/* 数字的颜色 描述的颜色 */
@property (nonatomic, strong) UIColor *numberColor;
@property (nonatomic, strong) UIColor *describColor;

/* 文字的字体 */
@property (nonatomic, strong) UIFont *stringFont;

@end
