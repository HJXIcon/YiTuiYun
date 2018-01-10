//
//  KNIconTitButton.m
//  社区快线
//
//  Created by LUKHA_Lu on 15/10/29.
//  Copyright © 2015年 beifanghudong. All rights reserved.
//

#import "KNIconTitButton.h"


@interface KNIconTitButton()

@property (nonatomic, weak) UIImageView *iconImg;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UILabel *numLabel;

@end

@implementation KNIconTitButton

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
    
    // 1.图片
    UIImageView *iconImg = [[UIImageView alloc] init];
    iconImg.frame = CGRectMake(self.width/2 - 15, 20, 30, 30);
    _iconImg = iconImg;
    [self addSubview:_iconImg];
    
    // 3.文字
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, CGRectGetMaxY(iconImg.frame) + 5, self.width, self.height - CGRectGetMaxY(iconImg.frame) - 5);
    label.textAlignment = NSTextAlignmentCenter;
    _label = label;
    [self addSubview:_label];
}

- (void)setIconString:(NSString *)iconString{
    _iconString = iconString;
    _iconImg.image = [UIImage imageNamed:iconString];
}

- (void)setDescribColor:(UIColor *)describColor{
    _describColor = describColor;
    _label.textColor = describColor;
}

- (void)setDescribString:(NSString *)describString{
    _describString = describString;
    _label.text = describString;
}

- (void)setStringFont:(UIFont *)stringFont{
    _label.font = stringFont;
}

- (void)setNumber:(NSInteger)number{
    _number = number;
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.backgroundColor = kUIColorFromRGB(0xfb7caf);
    
    numberLabel.layer.cornerRadius = 7;
    numberLabel.clipsToBounds = YES;
    
    NSString *str = [NSString stringWithFormat:@"%zd",number];
    CGSize size = [self titleNameLabelHeightContent:str withFont:[UIFont systemFontOfSize:13]];
    numberLabel.frame = CGRectMake(CGRectGetMaxX(_iconImg.frame) - 5, _iconImg.y - size.height + 10, size.width + 10, size.height);
    numberLabel.font = [UIFont systemFontOfSize:13];
    _numLabel = numberLabel;
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.text = str;
    if(number < 1){
        _numLabel.hidden = YES;
    }
    
    [self addSubview:_numLabel];
}

- (CGSize)titleNameLabelHeightContent:(NSString *)content withFont:(UIFont *)font
{
    //判断文字是否为空
    NSString *introduce = content;
    if (introduce.length == 0) {
        return CGSizeMake(0, 0);
    }
    
    //按字体大小15计算高度
    CGRect rect = [introduce boundingRectWithSize:CGSizeMake(ScreenWidth - 20, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    
    // 返回label高度
    return rect.size;
}

@end
