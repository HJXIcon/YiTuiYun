//
//  JXPlaceholderTextView.m
//  test
//
//  Created by 晓梦影 on 2016/11/9.
//  Copyright © 2016年 黄金星. All rights reserved.
//

#import "JXPlaceholderTextView.h"

@implementation JXPlaceholderTextView

// 监听通知
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        // 设置默认字体
        self.font = [UIFont systemFontOfSize:15];
        // 默认颜色
        self.placeholderColor = [UIColor grayColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JXTextDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

// 尺寸改变的时候就会调用
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

- (void)JXTextDidChange:(NSNotification *)noti{
    
    // 会重新调用drawRect：方法
    [self setNeedsDisplay];
}

//每次调用drawRect：方法，都会将以前的东西清除掉
- (void)drawRect:(CGRect)rect{
    
    // 普通文本 富文本
//    if(self.hasText)
    if (self.text.length || self.attributedText.length) {
        return;
    }
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = self.font;
    attr[NSForegroundColorAttributeName] = self.placeholderColor;
    
    // 画文字
    rect.origin.x = 5;
    rect.origin.y = 8;
    rect.size.width -= 2 * rect.origin.x;
    [self.placeholder drawInRect:rect withAttributes:attr];
    
}

#pragma mark -setter
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}



@end
