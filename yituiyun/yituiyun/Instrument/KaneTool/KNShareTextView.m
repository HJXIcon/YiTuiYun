//
//  KNShareTextView.m
//  EaseMobUITest
//
//  Created by LUKHA_Lu on 15/3/27.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import "KNShareTextView.h"

@interface KNShareTextView()<UITextViewDelegate>

@end

@implementation KNShareTextView

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay) name:UITextViewTextDidChangeNotification object:self];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = [placeHolder copy];
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

- (void)drawRect:(CGRect)rect{
    if(self.hasText) return;
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    if(self.font){
        attr[NSFontAttributeName] = self.font;
    }
    
    CGRect placeHolderRect;
    placeHolderRect.origin = CGPointMake(5, 7);
    
    CGFloat w = rect.size.width - placeHolderRect.origin.x * 2;
    CGFloat h = rect.size.height;
    
    placeHolderRect.size = CGSizeMake(w, h);
    
    [self.placeHolder drawInRect:placeHolderRect withAttributes:attr];
}

@end
