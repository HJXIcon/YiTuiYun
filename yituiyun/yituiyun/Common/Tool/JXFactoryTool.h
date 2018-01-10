//
//  JXFactoryTool.h
//  BYBStore
//
//  Created by 晓梦影 on 2017/9/27.
//  Copyright © 2017年 BYBStore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JXFactoryTool : NSObject
#pragma mark - <Label>
+ (UILabel *)creatLabel:(CGRect)frame
                   font:(UIFont *)font
              textColor:(UIColor *)textColor
                   text:(NSString *)text
          textAlignment:(NSTextAlignment)textAlignment;

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
                   action:(SEL)action;

#pragma mark - <UIImageView>
+ (UIImageView *)creatImageView:(CGRect)frame image:(UIImage *)image;

@end
