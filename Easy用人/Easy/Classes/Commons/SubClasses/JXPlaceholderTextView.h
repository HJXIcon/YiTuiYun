//
//  JXPlaceholderTextView.h
//  test
//
//  Created by 晓梦影 on 2016/11/9.
//  Copyright © 2016年 黄金星. All rights reserved.
//

#import <UIKit/UIKit.h>

/***
 * 带占位文字的textView
 */
@interface JXPlaceholderTextView : UITextView

/** 占位文字*/
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色*/
@property (nonatomic, strong) UIColor *placeholderColor;
@end
