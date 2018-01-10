//
//  UIImage+Image.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

+ (UIImage *)imageWithColor:(UIColor *)color {

    //描述一个矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    //获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    //使用color演示填充上下文
    CGContextSetFillColorWithColor(ctx, [color CGColor]);

    //渲染上下文
    CGContextFillRect(ctx, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}


/**
 *  修改图片size，按比例进行缩放
 *
 *  @param image      原图片
 *  @param targetSize 要修改的size
 *
 *  @return 修改后的图片
 */
+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}

//截取部分图像
+(UIImage *)getSubImageRect:(CGRect)rect andImage:(UIImage *)image
{
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

//将一张图片画在另一张上面合成一张图片
+(UIImage *)reDrawImage:(UIImage *)backImage andImage:(UIImage *)image{
    CGSize backImageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, 55);
    UIGraphicsBeginImageContext(backImageSize);
    backImage = [backImage stretchableImageWithLeftCapWidth:4 topCapHeight:4];//图片中间部分拉伸
    [backImage drawInRect:CGRectMake(0, 0, backImageSize.width,backImageSize.height)];
    
    [image drawInRect:CGRectMake((backImageSize.width - image.size.width) / 2,10, image.size.width, image.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultingImage;
}

//设置图片透明度

+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);

    CGContextDrawImage(ctx, area, image.CGImage);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;
    
}



+(UIImage *)IMGCompressed:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        
        NSAssert(!newImage,@"图片压缩失败");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 根据view生成图片
 
 @param view view
 @return image
 */
+ (UIImage *) createImageFromView:(UIView *)view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



/**
 获取颜色梯度图片

 @param frame frame
 @param colors 颜色
 @param locations 一个可选的NSNumber数组，决定每个渐变颜色的终止位置，这些值必须是递增的，数组的长度和colors的长度最好一致，
 @param startPoint  分别表示渐变层的起始位置和终止位置，这两个点被定义在一个单元坐标空间，[0,0]表示左上角位置，[1,1]表示右下角位置，默认值分别是[.5,0] and [.5,1]；
 @param endPoint 终止位置
 @return image
 */
+ (UIImage *)imageGradientWithFrame:(CGRect)frame
                             colors:(NSArray <UIColor *>*)colors
                          locations:(NSArray<NSNumber *> *)locations
                         startPoint:(CGPoint)startPoint
                           endPoint:(CGPoint)endPoint{
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    
    NSMutableArray *cols = [NSMutableArray array];
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cols addObject:(id)[obj CGColor]];
    }];
    
    [gradient setColors:cols];
    
    // 一个可选的NSNumber数组，决定每个渐变颜色的终止位置，这些值必须是递增的，数组的长度和colors的长度最好一致
    [gradient setLocations:locations];
    // 分别表示渐变层的起始位置和终止位置，这两个点被定义在一个单元坐标空间，[0,0]表示左上角位置，[1,1]表示右下角位置，默认值分别是[.5,0] and [.5,1]；
    [gradient setStartPoint:startPoint];
    [gradient setEndPoint:endPoint];
    
    UIGraphicsBeginImageContextWithOptions(gradient.frame.size, NO, [UIScreen mainScreen].scale);
    [gradient renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}



@end
