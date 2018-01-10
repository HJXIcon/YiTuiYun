//
//  CustomTitleButton.m
//  ChangeClothes
//
//  Created by hslhzj@163.com on 15/7/29.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#define BUTTON_START_TAG 1000

#import "CustomTitleButton.h"

@interface CustomTitleButton (){
    NSInteger _btnType;
    NSInteger _lineInButtonDown;//线是在label下还是在按钮下
    NSArray* _arrNormal;
    NSArray* _arrSelected;
    UIView* _line;
    CGFloat _btnHeight;
}

@end

@implementation CustomTitleButton

- (id)initWithFrame:(CGRect)frame withType:(NSInteger)type withLineInButtonDown:(NSInteger)isInDown withWantBtnHeight:(CGFloat)btnHeight{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _btnType = type;
        _lineInButtonDown = isInDown;
        _btnHeight = btnHeight;
    }
    return self;
}

-(void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    if (_btnType == 2) {
        _arrNormal = [NSArray arrayWithArray:[titleArr objectAtIndex:0]];
        _arrSelected = [NSArray arrayWithArray:[titleArr objectAtIndex:1]];
    }
    [self createButtons];
}

- (void)createButtons
{
    for (NSUInteger i = 0; i < self.titleArr.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake((self.frame.size.width / self.titleArr.count) * i, 0, self.frame.size.width / self.titleArr.count, self.frame.size.height);
        button.tag = BUTTON_START_TAG + i;
        if (_btnType == 1) {
            NSString* tempStr = [self.titleArr objectAtIndex:0];
            if (i == 0) {
                _line = [[UIView alloc] init];
                _line.backgroundColor = MainColor;
                [self addSubview:_line];
            }
            [button setTitle:[self.titleArr objectAtIndex:i] forState:UIControlStateNormal];
            CGRect tempFrame = CGRectMake(0, 0, 0, 2);
            if (_btnHeight != 0) {
                button.titleLabel.font = [UIFont systemFontOfSize:_btnHeight];
                tempFrame.origin.x = (button.frame.size.width - tempStr.length * _btnHeight) / 2;
                tempFrame.size.width = tempStr.length * _btnHeight;
            }else{
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                tempFrame.origin.x = (button.frame.size.width - tempStr.length * 18) / 2;
                tempFrame.size.width = tempStr.length * 18;
            }
            if (_lineInButtonDown) {
                tempFrame.origin.y = CGRectGetMaxY(button.frame) - 3;
            }else{
                if (_btnHeight) {
                    tempFrame.origin.y = CGRectGetMaxY(button.titleLabel.frame) + 8;
                }else{
                    tempFrame.origin.y = CGRectGetMaxY(button.titleLabel.frame) + 9;
                }
            }
            _line.frame = tempFrame;
            if (i == 0) {
                [button setTitleColor:MainColor forState:UIControlStateNormal];
                
            } else {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
        }else{
            UIImage * normalImage = [UIImage imageNamed:[_arrNormal objectAtIndex:i]];
            UIImage * selectedImage = [UIImage imageNamed:[_arrSelected objectAtIndex:i]];
            
            if (i == 0) {
                [button setBackgroundImage:selectedImage forState:UIControlStateNormal];
                
            } else {
                [button setBackgroundImage:normalImage forState:UIControlStateNormal];
            }
        }
        
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)buttonPressed:(UIButton *)button
{
    [self resetButtonImagesWithButton:button];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonPresedInTitle:)]) {
        [self.delegate buttonPresedInTitle:button.tag - BUTTON_START_TAG];
    }
}


-(void)changeTitleButtonIndex:(NSInteger)index{
    if (_btnType == 1) {
        for (NSInteger i = 0; i < self.titleArr.count; i++) {
            UIButton * btn = (UIButton *)[self viewWithTag:i + BUTTON_START_TAG];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //            [(UIButton *)[self viewWithTag:i + BUTTON_START_TAG] setTitleColor:NorColor forState:UIControlStateNormal];
        }
        UIButton * button = (UIButton *)[self viewWithTag:index + BUTTON_START_TAG];
        [button setTitleColor:MainColor forState:UIControlStateNormal];
        CGRect tempRect = _line.frame;
        tempRect.size.width = button.titleLabel.frame.size.width;
        tempRect.origin.x = button.titleLabel.frame.origin.x + button.frame.origin.x;
        if (tempRect.size.width == 0) {
            CGSize titleSize = [button.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:_btnHeight == 0 ? 15 : _btnHeight] maxSize:CGSizeMake(button.frame.size.width, button.frame.size.height)];
            tempRect.size.width = titleSize.width;
            tempRect.origin.x = button.frame.origin.x + (button.frame.size.width - titleSize.width) / 2;
        }
        [UIView animateWithDuration:0.3 animations:^{
            _line.frame = tempRect;
        }];
    }else{
        for (NSInteger i = 0; i < self.titleArr.count; i++) {
            UIButton * btn = (UIButton *)[self viewWithTag:i + BUTTON_START_TAG];
            NSString * normal = [_arrNormal objectAtIndex:i];
            UIImage * normalImage = [UIImage imageNamed:normal];
            [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        }
        NSString * selected = [_arrSelected objectAtIndex:index];
        UIImage * selectedImage = [UIImage imageNamed:selected];
        UIButton * button = (UIButton *)[self viewWithTag:index + BUTTON_START_TAG];
        [button setBackgroundImage:selectedImage forState:UIControlStateNormal];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonPresedInTitle:)]) {
        [self.delegate buttonPresedInTitle:index];
    }
}

- (void)resetButtonImagesWithButton:(UIButton*)button
{
    if (_btnType == 1) {
        for (NSInteger i = 0; i < self.titleArr.count; i++) {
            UIButton * btn = (UIButton *)[self viewWithTag:i + BUTTON_START_TAG];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [button setTitleColor:MainColor forState:UIControlStateNormal];
        CGRect tempRect = _line.frame;
        tempRect.size.width = button.titleLabel.frame.size.width;
        tempRect.origin.x = button.titleLabel.frame.origin.x + button.frame.origin.x;
        
        [UIView animateWithDuration:0.3 animations:^{
            _line.frame = tempRect;
        }];
    }else{
        for (NSInteger i = 0; i < self.titleArr.count; i++) {
            UIButton * btn = (UIButton *)[self viewWithTag:i + BUTTON_START_TAG];
            NSString * normal = [_arrNormal objectAtIndex:i];
            UIImage * normalImage = [UIImage imageNamed:normal];
            [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        }
        NSString * selected = [_arrSelected objectAtIndex:button.tag - BUTTON_START_TAG];
        UIImage * selectedImage = [UIImage imageNamed:selected];
        [button setBackgroundImage:selectedImage forState:UIControlStateNormal];
    }
}

-(void)changeIndex:(NSInteger)index{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonPresedInTitle:)]) {
        [self.delegate buttonPresedInTitle:index];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
