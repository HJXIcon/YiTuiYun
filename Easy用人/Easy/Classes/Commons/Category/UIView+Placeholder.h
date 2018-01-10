//
//  UIView+Placeholder.h
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/26.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Placeholder)
/** 加载*/
@property (nonatomic, copy) void(^reloadBlock)(void);
/** 字体颜色*/
@property (nonatomic, strong) UIColor *jx_placeholderColor;
/** 背景颜色*/
@property (nonatomic, strong) UIColor *jx_placeholderBackgroundColor;

/** 加载按钮背景颜色*/
@property (nonatomic, strong) UIColor *jx_reloadBtnBackgroundColor;

- (void)jx_showPlaceholderViewWithImageName:(NSString *)imageName
                       desText:(NSString *)desText
               reloadBtnTitle:(NSString *)reloadBtnTitle
                   reloadBlock:(void(^)(void))reloadBlock;
@end
