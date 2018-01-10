//
//  JXFactoryTool.m
//  BYBStore
//
//  Created by 晓梦影 on 2017/9/27.
//  Copyright © 2017年 BYBStore. All rights reserved.
//

#import "JXFactoryTool.h"

@implementation JXFactoryTool


#pragma mark - <Label>
+ (UILabel *)creatLabel:(CGRect)frame
                   font:(UIFont *)font
              textColor:(UIColor *)textColor
                   text:(NSString *)text
          textAlignment:(NSTextAlignment)textAlignment{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    if(textColor) label.textColor = textColor;
    if(text && text.length) label.text = text;
    if(font) label.font = font;
    if(textAlignment && textAlignment != NSTextAlignmentLeft) label.textAlignment = textAlignment;
    return label;
}


#pragma mark - <Button>
+ (UIButton *)creatButton:(CGRect)frame
                     font:(UIFont *)font
              normalColor:(UIColor *)normalColor
              selectColor:(UIColor *)selectColor
                    title:(NSString *)title
         nornamlImageName:(NSString *)nornamlImageName
          selectImageName:(NSString *)selectImageName
            textAlignment:(NSTextAlignment)textAlignment
                   target:(id)target
                   action:(SEL)action{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(font) btn.titleLabel.font = font;
    if(textAlignment && textAlignment != NSTextAlignmentLeft) btn.titleLabel.textAlignment = textAlignment;
    if(title.length) [btn setTitle:title forState:UIControlStateNormal];
    if(normalColor) [btn setTitleColor:normalColor forState:UIControlStateNormal];
    if(selectColor) [btn setTitleColor:selectColor forState:UIControlStateSelected];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if(nornamlImageName && nornamlImageName.length) [btn setImage:[UIImage imageNamed:nornamlImageName] forState:UIControlStateNormal];
    if(selectImageName && selectImageName.length) [btn setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateNormal];
    
    return btn;
    
}

#pragma mark - <UIImageView>
+ (UIImageView *)creatImageView:(CGRect)frame image:(UIImage *)image {
    UIImageView *iamgeV = [[UIImageView alloc]initWithFrame:frame];
    iamgeV.image = image;
    return iamgeV;
}


@end
