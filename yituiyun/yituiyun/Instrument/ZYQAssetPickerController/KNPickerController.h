//
//  KNPickerController.h
//  EaseMobUITest
//
//  Created by LUKHA_Lu on 15/4/24.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZYQAssetPickerController;

@interface KNPickerController : NSObject


/**
 *  图片选择器方法的抽出
 *
 *  @param viewController 每个控制器
 *  @param picker         图片选择器
 *  @param imagesCount    图片的当前数
 *  @param MaxCount       图片的最大数
 */
+ (void)imagePickerController:(UIViewController *)viewController withTakePicturePickerViewController:(ZYQAssetPickerController *)picker subViewsCount:(NSUInteger)imagesCount maxCount:(NSUInteger)MaxCount;

+ (void)imagePickerController:(UIViewController *)viewController withTakePhotoPickerViewController:(UIImagePickerController *)picker subViewsCount:(NSUInteger)imagesCount maxCount:(NSUInteger)MaxCount;

@end
