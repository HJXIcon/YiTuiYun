//
//  KNSubViewsBtn.m
//  社区快线
//
//  Created by LUKHA_Lu on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "KNSubViewsBtn.h"

@interface KNSubViewsBtn()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *describLabel;

@end

@implementation KNSubViewsBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setUp];
    }
    return self;
}

- (void)setUp{
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.width, self.height/2-5)];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.textColor = [UIColor blackColor];
    [self addSubview:_numberLabel];

    
    _describLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_numberLabel.frame), self.width, self.height/2-5)];
    _describLabel.textAlignment = NSTextAlignmentCenter;
    _describLabel.textColor = [UIColor blackColor];
    [self addSubview:_describLabel];
}

- (void)setNumberColor:(UIColor *)numberColor{
    _numberColor = numberColor;
    _numberLabel.textColor = numberColor;
}

- (void)setDescribColor:(UIColor *)describColor{
    _describColor = describColor;
    _describLabel.textColor = describColor;
}

- (void)setNumberString:(NSString *)numberString{
    _numberString = numberString;
    _numberLabel.text = numberString;
}

- (void)setDescribString:(NSString *)describString{
    _describString = describString;
    _describLabel.text = describString;
}

- (void)setStringFont:(UIFont *)stringFont{
    _numberLabel.font = stringFont;
    _describLabel.font = stringFont;
}

@end
