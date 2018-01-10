//
//  UIImage+Image.h
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define backImageSize (CGSizeMake([UIScreen mainScreen].bounds.size.width - 60, 55))

@interface UIImage (Image)

/**
 *  根据颜色生成一张图片
 *  @param color 提供的颜色
 */
+ (UIImage *)imageWithColor:(UIColor *)color;


/**
 *  修改图片size，按比例进行缩放
 *
 *  @param image      原图片
 *  @param targetSize 要修改的size
 *
 *  @return 修改后的图片
 */
+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize;

//截取图片的某一部分
+(UIImage*)getSubImageRect:(CGRect)rect andImage:(UIImage *)image;

+(UIImage *)reDrawImage:(UIImage *)backImage andImage:(UIImage *)image;

/**
 *  设置图片透明度
 * @param alpha 透明度
 * @param image 图片
 */
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;

/**
 *  图片的压缩方法
 *
 *  @param sourceImg   要被压缩的图片
 *  @param defineWidth 要被压缩的尺寸(宽)
 *
 *  @return 被压缩的图片
 */
+(UIImage *)IMGCompressed:(UIImage *)sourceImg targetWidth:(CGFloat)defineWidth;


/**
 根据view生成图片
 
 @param view view
 @return image
 */
+ (UIImage *) createImageFromView:(UIView *)view;

/**
 获取颜色梯度图片
 
 @param frame frame
 @param colors 颜色
 @param locations 决定每个渐变颜色的终止位置，这些值必须是递增的
 @param startPoint  起始位置
 @param endPoint 终止位置
 @return image
 */
+ (UIImage *)imageGradientWithFrame:(CGRect)frame
                             colors:(NSArray <UIColor *>*)colors
                          locations:(NSArray<NSNumber *> *)locations
                         startPoint:(CGPoint)startPoint
                           endPoint:(CGPoint)endPoint;
@end
