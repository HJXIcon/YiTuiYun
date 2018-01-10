//
//  HFNeighboursTitleButton.m
//  CommunityBBS
//
//  Created by joyman04 on 16/3/7.
//  Copyright © 2016年 HF. All rights reserved.
//
#define NorColor kUIColorFromRGB(0x808080)
#define SelColor kUIColorFromRGB(0xf16156)

#import "HFNeighboursTitleButton.h"
#import "HFNeighboursTitleModel.h"

@interface HFNeighboursTitleButton (){
    NSInteger _btnType;
    NSInteger _lineInButtonDown;//线是在label下还是在按钮下
    NSArray* _arrNormal;
    NSArray* _arrSelected;
    UIView* _line;
    CGFloat _btnHeight;
}

@property (nonatomic,strong) NSMutableArray* buttonArr;

@end

@implementation HFNeighboursTitleButton

- (id)initWithFrame:(CGRect)frame withType:(NSInteger)type withLineInButtonDown:(NSInteger)isInDown withWantBtnHeight:(CGFloat)btnHeight{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _btnType = type;
        _lineInButtonDown = isInDown;
        _btnHeight = btnHeight;
        self.bounces = NO;
        self.buttonArr = [NSMutableArray new];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.directionalLockEnabled = YES;
    }
    return self;
}

-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    if (_btnType == 2) {
        _arrNormal = [NSArray arrayWithArray:[titles objectAtIndex:0]];
        _arrSelected = [NSArray arrayWithArray:[titles objectAtIndex:1]];
    }
    [self createButtons];
}

- (void)createButtons{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1];
    [self addSubview:line];
    
    CGFloat x = 0;
    for (NSUInteger i = 0; i < self.titles.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGSize nameSize = [self.titles[i] sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        
        button.frame = CGRectMake(x, 0, nameSize.width + 25, self.frame.size.height - 1.5);
        
        x = x + nameSize.width + 25;
        
        button.tag = i;
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        if (i == 0) {
            [button setTitleColor:SelColor forState:UIControlStateNormal];
        } else {
            [button setTitleColor:NorColor forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (i == 0) {
            _line = [[UIView alloc] init];
            _line.frame = CGRectMake(0, CGRectGetMaxY(button.frame), button.frame.size.width, 1.5);
            _line.backgroundColor = kUIColorFromRGB(0xf16156);
            [self addSubview:_line];
            
        }
        
//        UIView* tempLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), self.frame.size.height / 3, 0.5, self.frame.size.height / 3)];
//        tempLine.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
        if (i == self.titles.count - 1) {
            self.contentSize = CGSizeMake(CGRectGetMaxX(button.frame) + 20, self.frame.size.height);
        }
//        [self addSubview:tempLine];
        [self.buttonArr addObject:button];
    }
}

- (void)buttonPressed:(UIButton *)button
{
    if (_btnType == 1) {
        for (UIButton* tempBtn in self.buttonArr) {
            
            [tempBtn setTitleColor:NorColor forState:UIControlStateNormal];
        }
        [button setTitleColor:SelColor forState:UIControlStateNormal];
        
        if (CGRectGetMaxX(button.frame) - self.contentOffset.x > self.frame.size.width) {
            [self setContentOffset:CGPointMake(CGRectGetMaxX(button.frame) - self.frame.size.width, 0) animated:YES];
        }else if (button.frame.origin.x < self.contentOffset.x){
            [self setContentOffset:CGPointMake(button.frame.origin.x, 0) animated:YES];
        }
        
        CGRect tempRect = _line.frame;
        tempRect.size.width = button.titleLabel.frame.size.width;
        tempRect.origin.x = button.titleLabel.frame.origin.x + button.frame.origin.x;
        [UIView animateWithDuration:0.3 animations:^{
            _line.frame = tempRect;
        }];
    }else{
        for (NSInteger i = 0; i < self.buttonArr.count; i++) {
            UIButton * btn = (UIButton *)[self viewWithTag:i];
            NSString * normal = [_arrNormal objectAtIndex:i];
            UIImage * normalImage = [UIImage imageNamed:normal];
            [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        }
        NSString * selected = [_arrSelected objectAtIndex:button.tag];
        UIImage * selectedImage = [UIImage imageNamed:selected];
        [button setBackgroundImage:selectedImage forState:UIControlStateNormal];
    }
    
    if (self.neighboursDelegate && [self.neighboursDelegate respondsToSelector:@selector(neighboursTitleSelectWithIndex:)]) {
        [self.neighboursDelegate neighboursTitleSelectWithIndex:button.tag];
    }
}

-(void)changeTitleButtonIndex:(NSInteger)index{
    if (_btnType == 1) {
        for (NSInteger i = 0; i < self.buttonArr.count; i++) {
            UIButton * btn = self.buttonArr[i];
            [btn setTitleColor:NorColor forState:UIControlStateNormal];
        }
        UIButton * button = self.buttonArr[index];
        [button setTitleColor:SelColor forState:UIControlStateNormal];
        
        if (CGRectGetMaxX(button.frame) - self.contentOffset.x > self.frame.size.width) {
            [self setContentOffset:CGPointMake(CGRectGetMaxX(button.frame) - self.frame.size.width, 0) animated:YES];
        }else if (button.frame.origin.x < self.contentOffset.x){
            [self setContentOffset:CGPointMake(button.frame.origin.x, 0) animated:YES];
        }
        
        CGRect tempRect = _line.frame;
        tempRect.size.width = button.titleLabel.frame.size.width;
        tempRect.origin.x = button.titleLabel.frame.origin.x + button.frame.origin.x;
        [UIView animateWithDuration:0.3 animations:^{
            _line.frame = tempRect;
        }];
    }else{
        for (NSInteger i = 0; i < self.buttonArr.count; i++) {
            UIButton * btn = self.buttonArr[i];
            NSString * normal = [_arrNormal objectAtIndex:i];
            UIImage * normalImage = [UIImage imageNamed:normal];
            [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        }
        NSString * selected = [_arrSelected objectAtIndex:index];
        UIImage * selectedImage = [UIImage imageNamed:selected];
        UIButton * button = self.buttonArr[index];
        [button setBackgroundImage:selectedImage forState:UIControlStateNormal];
    }
    if (self.neighboursDelegate && [self.neighboursDelegate respondsToSelector:@selector(neighboursTitleSelectWithIndex:)]) {
        [self.neighboursDelegate neighboursTitleSelectWithIndex:index];
    }
}

- (void)resetButtonImagesWithButton:(UIButton*)button{
    
}

-(void)changeIndex:(NSInteger)index{
    
    if (self.neighboursDelegate && [self.delegate respondsToSelector:@selector(neighboursTitleSelectWithIndex:)]) {
        [self.neighboursDelegate neighboursTitleSelectWithIndex:index];
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
