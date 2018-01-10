//
//  KNTitleBtn.m
//  EaseMobUITest
//
//  Created by LUKHA_Lu on 15/3/30.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import "KNTitleBtn.h"

@implementation KNTitleBtn

/**
 * init方法内部会调用这个方法
 * 只有通过代码创建控件,才会执行这个方法
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

/**
 * 通过xib\storyboard创建控件时,才会执行这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

/**
 * 初始化
 */
- (void)setup
{
    [self setTitleColor:kUIColorFromRGB(0x666666) forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 文字
    self.titleLabel.x = self.width * 0.5 - 16;
    
    // 图片
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self layoutSubviews];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted{
    
}

@end
