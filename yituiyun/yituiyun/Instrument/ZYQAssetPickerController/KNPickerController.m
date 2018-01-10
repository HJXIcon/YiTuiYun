//
//  KNPickerController.m
//  EaseMobUITest
//
//  Created by LUKHA_Lu on 15/4/24.
//  Copyright (c) 2015年 BFHD. All rights reserved.
//

#import "KNPickerController.h"
#import "ZYQAssetPickerController.h"
//#import "KNStatusHUD.h"

@implementation KNPickerController

// 相册/视频
+ (void)imagePickerController:(UIViewController *)viewController withTakePicturePickerViewController:(ZYQAssetPickerController *)picker subViewsCount:(NSUInteger)imagesCount maxCount:(NSUInteger)MaxCount{
    NSUInteger count = imagesCount;
    if (count >= MaxCount) {
//        [MBProgressHUD showMessage:@""];
    } else {
        picker.maximumNumberOfSelection = MaxCount - count;
        picker.showEmptyGroups = NO;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        [viewController presentViewController:picker animated:YES completion:NULL];
    }
}

// 拍照
+ (void)imagePickerController:(UIViewController *)viewController withTakePhotoPickerViewController:(UIImagePickerController *)picker subViewsCount:(NSUInteger)imagesCount maxCount:(NSUInteger)MaxCount{
     NSUInteger count = imagesCount;
     if (count == MaxCount) {
//     [KNStatusHUD showError:[NSString stringWithFormat:@"已经选够%zd张图片了", MaxCount]];
     } else {
         picker.sourceType = UIImagePickerControllerSourceTypeCamera;
         picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
         picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
         [viewController presentViewController:picker animated:YES completion:nil];
         
     }
}

@end
